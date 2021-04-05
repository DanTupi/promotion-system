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

  test 'show one promotion' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user: user)

    get "/api/v1/promotions/#{promotion.id}"
    
    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.name, body[:name]
  end

  test 'show all promotions' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion_01 = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user: user)
    promotion_02 = Promotion.create!(name: 'Casa', description: 'Promoção de Casa',
                                    code: 'CASA10', discount_rate: 10,
                                    coupon_quantity: 20,
                                    expiration_date: '1/12/2022', user: user)

    get "/api/v1/promotions"
    p promotion_01

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)

    assert_equal promotion_01.name, body.first[:name]
    assert_equal promotion_02.name, body.last[:name]
  end

  test 'create a promotion' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion = {promotion: {name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user_id: user.id}}
  
    post api_v1_promotions_path(promotion)
    p promotion
    p body

    body = JSON.parse(response.body, symbolize_names: true)
    
    assert_response :success
    assert_response 201
    assert_equal promotion.name, body[:name]


  end

end
