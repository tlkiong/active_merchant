module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module JReserveCodes
      # Language code follows ISO 639-1 standard

      ERROR_CODES = {
        'S20010001' => {
          'en' => 'Processing category (job) not found',
          'ja' => '処理区分(job)が見つかりません'
        },
        'S20010002' => {
          'en' => 'Processing classification (job) is an invalid value.',
          'ja' => '処理区分(job)が不正な値です'
        },
        'S20020001' => {
          'en' => 'Merchant Identification Code (member_code) not found',
          'ja' => '加盟店識別コード(member_code)が見つかりません'
        },
        'S20020002' => {
          'en' => 'Merchant identification code (member_code) is an invalid value',
          'ja' => '加盟店識別コード(member_code)が不正な値です'
        },
        'S20020003' => {
          'en' => 'It is an unregistered member store',
          'ja' => '未登録の加盟店です'
        },
        'S20030001' => {
          'en' => 'Transaction identification code (order_code) not found',
          'ja' => '取引識別コード(order_code)が見つかりません'
        },
        'S20030002' => {
          'en' => 'Transaction identification code (order_code) is invalid',
          'ja' => '取引識別コード(order_code)が不正な値です'
        },
        'S20040001' => {
          'en' => 'Merchant reservation identification code (proposal_code) not found',
          'ja' => '加盟店予約識別コード(proposal_code)が見つかりません'
        },
        'S20040002' => {
          'en' => 'Merchant reservation identification code (proposal_code) is an invalid value',
          'ja' => '加盟店予約識別コード(proposal_code)が不正な値です'
        },
        'S20040003' => {
          'en' => 'Merchant reservation identification code (proposal_code) is duplicated (VIEW)',
          'ja' => '加盟店予約識別コード(proposal_code)が重複しています(VIEW)'
        },
        'S20050001' => {
          'en' => 'Card brand name (card_brand) not found',
          'ja' => 'カードブランド名(card_brand)が見つかりません'
        },
        'S20050002' => {
          'en' => 'Card brand name (card_brand) is an invalid value',
          'ja' => 'カードブランド名(card_brand)が不正な値です'
        },
        'S20060001' => {
          'en' => 'Card number (card_no) not found',
          'ja' => 'カード番号(card_no)が見つかりません'
        },
        'S20060002' => {
          'en' => 'Card number (card_no) is invalid',
          'ja' => 'カード番号(card_no)が不正な値です'
        },
        'S20070001' => {
          'en' => 'Card expiration date / year (expire_year) not found',
          'ja' => 'カード有効期限・年(expire_year)が見つかりません'
        },
        'S20070002' => {
          'en' => 'Invalid card expiration date / year (expire_year)',
          'ja' => 'カード有効期限・年(expire_year)が不正な値です'
        },
        'S20080001' => {
          'en' => 'Card Expiration Date / Month (expire_month) not found',
          'ja' => 'カード有効期限・月(expire_month)が見つかりません'
        },
        'S20080002' => {
          'en' => 'Invalid card expiration date / month (expire_month)',
          'ja' => 'カード有効期限・月(expire_month)が不正な値です'
        },
        'S20090001' => {
          'en' => 'Settlement amount (amount) not found',
          'ja' => '決済金額(amount)が見つかりません'
        },
        'S20090002' => {
          'en' => 'Settlement amount (amount) is an invalid value',
          'ja' => '決済金額(amount)が不正な値です'
        },
        'S20100002' => {
          'en' => 'Sales start date is incorrect',
          'ja' => '販売開始日が不正な値です'
        },
        'S20110002' => {
          'en' => 'End date of sale is an invalid value',
          'ja' => '販売終了日が不正な値です'
        },
        'S20120001' => {
          'en' => 'Customer E-mail address (customer_mail) not found',
          'ja' => 'お客様E-Mailアドレス(customer_mail)が見つかりません'
        },
        'S20120002' => {
          'en' => 'Customer E-mail address (customer_mail) is an invalid value',
          'ja' => 'お客様E-Mailアドレス(customer_mail)が不正な値です'
        },
        'S20130001' => {
          'en' => 'The cancellation fee base amount (cancel_base_fee) can not be found',
          'ja' => 'キャンセル料金の基本金額(cancel_base_fee)が見つかりません'
        },
        'S20130002' => {
          'en' => 'Failed to calculate cancellation fee',
          'ja' => 'キャンセル料金の算出に失敗しました'
        },
        'S20140001' => {
          'en' => "Customer's name is incorrect",
          'ja' => 'お客様氏名が不正な値です'
        },
        'S20140002' => {
          'en' => 'Card holder name is invalid',
          'ja' => 'カードホルダ名が不正な値です'
        },
        'S20140003' => {
          'en' => 'The address is invalid',
          'ja' => '住所が不正な値です'
        },
        'S20150001' => {
          'en' => 'MD not found',
          'ja' => 'MDが見つかりません'
        },
        'S20150002' => {
          'en' => 'MD is invalid',
          'ja' => 'MDが不正な値な値です'
        },
        'S20150003' => {
          'en' => 'PaRes not found',
          'ja' => 'PaResが見つかりません'
        },
        'S20160001' => {
          'en' => 'Return URL not found',
          'ja' => '戻り先URLが見つかりません'
        },
        'S20160002' => {
          'en' => 'Specified range of effective time is abnormal',
          'ja' => '有効時間の指定範囲が異常です'
        },
        'S20160003' => {
          'en' => 'Expired time exceeded',
          'ja' => '有効時間を超過しました'
        },
        # Start: 以下のエラーが発生した場合、弊社までご連絡下さい (Please contact J-Reserve if the following error occurs)
        'S10000000' => {
          'en' => 'A system error has occurred.',
          'ja' => 'システムエラーが発生しました'
        },
        'S10000001' => {
          'en' => 'Temporary sales processing failed',
          'ja' => '仮売上処理に失敗しました'
        },
        'S10000002' => {
          'en' => 'Cancel processing failed',
          'ja' => '取消処理に失敗しました'
        },
        'S30010001' => {
          'en' => 'Connection to payment information DB failed',
          'ja' => '決済情報用DBへの接続に失敗しました'
        },
        'S30020001' => {
          'en' => 'Merchant',
          'ja' => 'カード情報用DBへの接続に失敗しました'
        },
        'S30030001' => {
          'en' => 'Registration of payment basic information failed',
          'ja' => '決済基本情報の登録に失敗しました'
        },
        'S30030002' => {
          'en' => 'Failed to register payment details',
          'ja' => '決済詳細情報の登録に失敗しました'
        },
        'S30030003' => {
          'en' => 'Failed to register card information',
          'ja' => 'カード情報の登録に失敗しました'
        },
        'S30030004' => {
          'en' => 'Failed to register GMO communication history information',
          'ja' => 'GMO通信履歴情報の登録に失敗しました'
        },
        'S30030005' => {
          'en' => 'Failed to confirm payment basic information',
          'ja' => '決済基本情報の確定に失敗しました'
        },
        'S30030006' => {
          'en' => 'Failed to confirm card information',
          'ja' => 'カード情報の確定に失敗しました'
        },
        'S30030007' => {
          'en' => 'Registration of re-authentication card information failed',
          'ja' => '再認証用カード情報の登録に失敗しました'
        },
        'S30040001' => {
          'en' => 'Failed to register GMO communication history information',
          'ja' => 'GMO通信履歴情報の登録に失敗しました'
        },
        'S30040002' => {
          'en' => 'Failed to register GMO communication history information',
          'ja' => 'GMO通信履歴情報の登録に失敗しました'
        },
        'S30040003' => {
          'en' => 'Failed to register GMO communication history information',
          'ja' => 'GMO通信履歴情報の登録に失敗しました'
        },
        'S30040004' => {
          'en' => 'Failed to update payment status',
          'ja' => '決済状態の更新に失敗しました'
        },
        'S40010001' => {
          'en' => 'Failed to register transaction information for temporary sales',
          'ja' => '仮売上の取引情報登録に失敗しました'
        },
        'S40010002' => {
          'en' => 'Failed to confirm temporary sales transaction information',
          'ja' => '仮売上の取引情報確定に失敗しました'
        },
        'S40020001' => {
          'en' => 'Transaction cancellation failed',
          'ja' => '取引の取消処理に失敗しました'
        },
        'S40020002' => {
          'en' => 'Transaction return processing failed',
          'ja' => '取引の返品処理に失敗しました'
        },
        'S40020003' => {
          'en' => 'Failed to register cancellation fee',
          'ja' => 'キャンセル料金の登録に失敗しました'
        }
        # End: 以下のエラーが発生した場合、弊社までご連絡下さい (Please contact J-Reserve if the following error occurs)
      }.freeze
    end
  end
end
