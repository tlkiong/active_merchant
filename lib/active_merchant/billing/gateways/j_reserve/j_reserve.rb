require 'cgi'
require 'active_merchant/billing/gateways/j_reserve/j_reserve_codes'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class JReserveGateway < Gateway
      include ActiveMerchant::Billing::JReserveCodes

      self.test_url = 'https://test.j-reserve.com:10443/ros/settlement.php'
      self.live_url = 'https://credit.j-reserve.com/ros/settlement.php'

      self.supported_countries = ['US']
      self.default_currency = 'JPY'
      self.supported_cardtypes = [:visa, :master, :american_express]

      self.homepage_url = 'http://www.example.net/'
      self.display_name = 'J-Reserve'
      self.money_format = :cents

      def initialize(options={})
        requires!(options, :member_code)
        @member_code = options[:member_code]
        # Language code follows ISO 639-1 standard
        @lang = options[:lang] || 'ja' # primarily used for messages returned API
        
        raise ArgumentError, "member_code must be a number" unless @member_code.is_a? Numeric

        super
      end

      # def purchase(options)
      # end

      def authorize(options)
        requires!(options, :proposal_code, :card_brand, :card_number, :expire_year, :expire_month, :amount, :cancel_base_fee, :sales_start, :sales_end, :customer_email, :customer_name)
        post = init_post('AUTH', options)
        commit(post)
      end

      def capture(order_code)
        post = init_post('COMMIT', { order_code: order_code })
        commit(post)
      end

      # def refund(money, authorization, options={})
      #   commit('refund', post)
      # end

      def void(order_code)
        post = init_post('VOID', { order_code: order_code })
        commit(post)
      end

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
        def init_post(job_type, options={})
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

        def parse(response)
          # Example of response will be: 
          #     result=0&order_code=&error_type=S&error_code=S20&error_info=S20010001

          # CGI.parse will return a Hash with its value as an array
          response_hash = CGI::parse(response)
          response_hash.transform_values(&:first)
        end

        def commit(parameters)
          url = (test? ? test_url : live_url)
          params = parameters.to_json
          response = ssl_post(url, params, request_headers)
          response_hash = parse(response)

          Response.new(
            success_from(response_hash),
            message_from(response_hash),
            response_hash,
            authorization: authorization_from(response),
            # avs_result: AVSResult.new(code: response["some_avs_response_key"]),
            # cvv_result: CVVResult.new(response["some_cvv_response_key"]),
            test: test?,
            error_code: error_code_from(response_hash)
          )
        end

        def success_from(response_hash)
          response_hash['result'] === '1' # Value is either 0 / 1. 0 = error
        end

        def message_from(response_hash)
          if success_from(response_hash)
            response_hash['order_code']
          else
            error_message_from(response_hash)
          end
        end

        def authorization_from(response_hash)
          response_hash['order_code']
        end

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
            ERROR_CODES[response_hash['error_info']][@lang]
          end
        end

        def error_code_from(response_hash)
          unless success_from(response_hash)
            response_hash['error_info']
          end
        end
    end
  end
end
