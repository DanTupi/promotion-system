require 'test_helper'

class PromotionMailerTest < ActionMailer::TestCase
  test 'approval_email' do
    user = User.create!(email: 'approver@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    email = PromotionMailer.with(approver: user, promotion: promotion).approval_email

    assert_emails(1) { email.deliver_now }
    assert_equal [promotion.user.email], email.to
    assert_includes email.body, user.email
    assert_equal 'Sua promoção "Natal" foi aprovada', email.subject
  end
end
