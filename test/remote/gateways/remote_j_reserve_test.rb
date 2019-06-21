require 'test_helper'

class RemoteJReserveTest < Test::Unit::TestCase
  def setup
    @gateway = JReserveGateway.new(fixtures(:j_reserve))
    JReserveGateway.ssl_strict = false

    @test_val = {
      :card => {
        :number => 4111111111111111,
        :expire_year => default_expiration_date.strftime('%y'), # Has to be 2 digit
        :expire_month => default_expiration_date.month
      }
    }
  end

  # def test_successful_purchase
  # end

  # def test_successful_purchase_with_more_options
  #   options = {
  #     order_id: '1',
  #     ip: "127.0.0.1",
  #     email: "joe@example.com"
  #   }

  #   response = @gateway.purchase(@amount, @credit_card, options)
  #   assert_success response
  #   assert_equal 'REPLACE WITH SUCCESS MESSAGE', response.message
  # end

  # TODO:
  # def test_failed_purchase
  #   response = @gateway.purchase(@amount, @declined_card, @options)
  #   assert_failure response
  #   assert_equal 'REPLACE WITH FAILED PURCHASE MESSAGE', response.message
  # end

  def test_successful_authorize_and_capture
    purchase_options = {
      :proposal_code => "testCode1",
      :card_brand => "VISA",
      :card_no => @test_val[:card][:number],
      :expire_year => @test_val[:card][:expire_year],
      :expire_month => @test_val[:card][:expire_month],
      :amount => 1000,
      :cancel_base_fee => 100,
      :sales_start => (Date.today + 1).strftime("%Y-%m-%d"),
      :sales_end => (Date.today + 2).strftime("%Y-%m-%d"),
      :customer_mail => "test@gmail.com",
      :customer_name => "Test User"
    }
    
    response = @gateway.authorize(purchase_options)

    assert_success response
    assert_equal '1', response.params['result']

    capture = @gateway.capture(response.authorization)
    assert_success capture
    assert_equal response.authorization, capture.authorization
  end

  def test_successful_authorize_and_void
    purchase_options = {
      :proposal_code => "testCode1",
      :card_brand => "VISA",
      :card_no => @test_val[:card][:number],
      :expire_year => @test_val[:card][:expire_year],
      :expire_month => @test_val[:card][:expire_month],
      :amount => 1000,
      :cancel_base_fee => 100,
      :sales_start => (Date.today + 1).strftime("%Y-%m-%d"),
      :sales_end => (Date.today + 2).strftime("%Y-%m-%d"),
      :customer_mail => "test@gmail.com",
      :customer_name => "Test User"
    }
    
    response = @gateway.authorize(purchase_options)

    assert_success response
    assert_equal '1', response.params['result']

    void = @gateway.void(response.authorization)
    assert_success void
    assert_equal response.authorization, void.authorization
  end

  def test_failed_authorize
    purchase_options = {
      :proposal_code => "testCode1",
      :card_brand => "MASTERCARD",
      :card_no => @test_val[:card][:number],
      :expire_year => @test_val[:card][:expire_year],
      :expire_month => @test_val[:card][:expire_month],
      :amount => 1000,
      :cancel_base_fee => 100,
      :sales_start => (Date.today + 1).strftime("%Y-%m-%d"),
      :sales_end => (Date.today + 2).strftime("%Y-%m-%d"),
      :customer_mail => "test@gmail.com",
      :customer_name => "Test User"
    }
    
    response = @gateway.authorize(purchase_options)

    assert_failure response
    assert_equal '0', response.params['result']
  end

  # def test_partial_capture
  #   auth = @gateway.authorize(@amount, @credit_card, @options)
  #   assert_success auth

  #   assert capture = @gateway.capture(@amount-1, auth.authorization)
  #   assert_success capture
  # end

  # def test_failed_capture
  #   response = @gateway.capture(@amount, '')
  #   assert_failure response
  #   assert_equal 'REPLACE WITH FAILED CAPTURE MESSAGE', response.message
  # end

  # def test_successful_refund
  #   purchase = @gateway.purchase(@amount, @credit_card, @options)
  #   assert_success purchase

  #   assert refund = @gateway.refund(@amount, purchase.authorization)
  #   assert_success refund
  #   assert_equal 'REPLACE WITH SUCCESSFUL REFUND MESSAGE', refund.message
  # end

  # def test_partial_refund
  #   purchase = @gateway.purchase(@amount, @credit_card, @options)
  #   assert_success purchase

  #   assert refund = @gateway.refund(@amount-1, purchase.authorization)
  #   assert_success refund
  # end

  # def test_failed_refund
  #   response = @gateway.refund(@amount, '')
  #   assert_failure response
  #   assert_equal 'REPLACE WITH FAILED REFUND MESSAGE', response.message
  # end

  # def test_successful_void
  #   auth = @gateway.authorize(@amount, @credit_card, @options)
  #   assert_success auth

  #   assert void = @gateway.void(auth.authorization)
  #   assert_success void
  #   assert_equal 'REPLACE WITH SUCCESSFUL VOID MESSAGE', void.message
  # end

  # def test_failed_void
  #   response = @gateway.void('')
  #   assert_failure response
  #   assert_equal 'REPLACE WITH FAILED VOID MESSAGE', response.message
  # end

  # def test_successful_verify
  #   response = @gateway.verify(@credit_card, @options)
  #   assert_success response
  #   assert_match %r{REPLACE WITH SUCCESS MESSAGE}, response.message
  # end

  # def test_failed_verify
  #   response = @gateway.verify(@declined_card, @options)
  #   assert_failure response
  #   assert_match %r{REPLACE WITH FAILED PURCHASE MESSAGE}, response.message
  # end

  # def test_invalid_login
  #   gateway = JReserveGateway.new(login: '', password: '')

  #   response = gateway.purchase(@amount, @credit_card, @options)
  #   assert_failure response
  #   assert_match %r{REPLACE WITH FAILED LOGIN MESSAGE}, response.message
  # end

  # def test_dump_transcript
  #   # This test will run a purchase transaction on your gateway
  #   # and dump a transcript of the HTTP conversation so that
  #   # you can use that transcript as a reference while
  #   # implementing your scrubbing logic.  You can delete
  #   # this helper after completing your scrub implementation.
  #   dump_transcript_and_fail(@gateway, @amount, @credit_card, @options)
  # end

  # def test_transcript_scrubbing
  #   transcript = capture_transcript(@gateway) do
  #     @gateway.purchase(@amount, @credit_card, @options)
  #   end
  #   transcript = @gateway.scrub(transcript)

  #   assert_scrubbed(@credit_card.number, transcript)
  #   assert_scrubbed(@credit_card.verification_value, transcript)
  #   assert_scrubbed(@gateway.options[:password], transcript)
  # end

end
