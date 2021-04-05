require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal coupon.code, body[:code]
  end
end
