require 'cgi'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class JReserveGateway < Gateway
      self.test_url = 'https://test.j-reserve.com:10443/ros/settlement.php'
      self.live_url = 'https://credit.j-reserve.com/ros/settlement.php'

      self.supported_countries = ['US']
      self.default_currency = 'JPY'
      self.supported_cardtypes = [:visa, :master, :american_express]

      self.homepage_url = 'http://www.example.net/'
      self.display_name = 'J-Reserve'
      self.money_format = :cents

      STANDARD_ERROR_CODE_MAPPING = {
        'S10000000' => 'A system error has occurred.',
        'S10000001' => 'Temporary sales processing failed',
        'S10000002' => 'Cancel processing failed',
        'S20010001' => 'Processing category (job) not found'
      }

      def initialize(options={})
        requires!(options, :member_code)
        @member_code = options[:member_code]
        raise ArgumentError, "member_code must be a number" unless @member_code.is_a? Numeric

        super
      end

      def purchase(options)
        requires!(options, :proposal_code, :card_brand, :card_number, :expire_year, :expire_month, :amount, :cancel_base_fee, :sales_start, :sales_end, :customer_email, :customer_name)
        post = new_post('AUTH', options)
        commit(post)
      end

      # def authorize(money, payment, options={})
      #   post = {}
      #   add_invoice(post, money, options)
      #   add_payment(post, payment)
      #   add_address(post, payment, options)
      #   add_customer_data(post, options)

      #   commit('authonly', post)
      # end

      # def capture(money, authorization, options={})
      #   commit('capture', post)
      # end

      # def refund(money, authorization, options={})
      #   commit('refund', post)
      # end

      # def void(authorization, options={})
      #   commit('void', post)
      # end

      # def verify(credit_card, options={})
      #   MultiResponse.run(:use_first_response) do |r|
      #     r.process { authorize(100, credit_card, options) }
      #     r.process(:ignore_result) { void(r.authorization, options) }
      #   end
      # end

      # def supports_scrubbing?
      #   true
      # end

      # def scrub(transcript)
      #   transcript
      # end

      private

        # values are:
        #   {
        #     member_code: number,
        #     job: string,
        #     proposal_code: string,
        #     card_brand: string,
        #     card_number: number,
        #     expire_year: number,
        #     expire_month: number,
        #     amount: number,
        #     cancel_base_fee: number,
        #     sales_start: string,
        #     sales_end: string,
        #     customer_email: string,
        #     customer_name: string,
        #   }
        def new_post(job_type, options)
          post = {
            member_code: @member_code,
            job: job_type
          }

          options.merge(post)
        end

        # def add_customer_data(post, options)
        # end

        # def add_address(post, creditcard, options)
        # end

        # # def add_invoice(post, money, options)
        # #   post[:amount] = amount(money)
        # #   post[:currency] = (options[:currency] || currency(money))
        # # end

        # def add_payment(post, payment)
        # end

        # def parse(body)
        #   {}
        # end

        def commit(parameters)
          url = (test? ? test_url : live_url)
          params = parameters.to_json
          response = ssl_post(url, params, request_headers)

          # Example of response will be: 
          #     result=0&order_code=&error_type=S&error_code=S20&error_info=S20010001
          response_hash = CGI::parse(response)

          Response.new(
            success_from(response_hash),
            message_from(response_hash),
            response_hash,
            # authorization: authorization_from(response),
            # avs_result: AVSResult.new(code: response["some_avs_response_key"]),
            # cvv_result: CVVResult.new(response["some_cvv_response_key"]),
            test: test?,
            error_code: error_code_from(response_hash)
          )
        end

        def success_from(response_hash)
          response_hash['result'].first === '1' # Value is either 0 / 1. 0 means have error
        end

        def message_from(response_hash)
          if success_from(response_hash)
            # 
          else
            error_message_from(response_hash)
          end
        end

        # def authorization_from(response)
        # end

        # def post_data(action, parameters = {})
        #   JSON.generate(parameters)
        # end

        def request_headers()
          {
            'Content-Type' => 'application/json',
          }
        end

        def error_message_from(response_hash)
          unless success_from(response_hash)
            STANDARD_ERROR_CODE_MAPPING[response_hash['error_info'].first]
          end
        end

        def error_code_from(response_hash)
          unless success_from(response_hash)
            response_hash['error_info'].first
          end
        end
    end
  end
end
