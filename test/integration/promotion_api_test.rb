require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.discount_rate.to_s, body[:discount_rate]
  end

  test 'show coupon not found' do
    get '/api/v1/coupons/0', as: :json

    assert_response :not_found
  end

  test 'route invalid without json header' do
    assert_raises ActionController::RoutingError do
      get '/api/v1/coupons/0'
    end
  end

  test 'show one promotion' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user: user)

    get "/api/v1/promotions/#{promotion.id}", as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal promotion.name, body[:name]
  end

  test 'show all promotions' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    first_promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                        code: 'NATAL10', discount_rate: 14,
                                        coupon_quantity: 10,
                                        expiration_date: '12/12/2023', user: user)
    second_promotion = Promotion.create!(name: 'Casa', description: 'Promoção de Casa',
                                         code: 'CASA10', discount_rate: 10,
                                         coupon_quantity: 20,
                                         expiration_date: '1/12/2022', user: user)

    get api_v1_promotions_path, as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal first_promotion.name, body.first[:name]
    assert_equal second_promotion.name, body.last[:name]
  end

  test 'show coupon disabled' do
    user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 14,
                                  coupon_quantity: 10,
                                  expiration_date: '12/12/2023', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion,
                            status: :disabled)

    get "/api/v1/coupons/#{coupon.code}", as: :json

    assert_response :not_found
  end

  # test 'create a promotion' do
  #   user = User.create!(email: 'apeino@iugu.com.br', password: '123456')
  #   promotion = {promotion: {name: 'Natal', description: 'Promoção de Natal',
  #                                 code: 'NATAL10', discount_rate: 14,
  #                                 coupon_quantity: 10,
  #                                 expiration_date: '12/12/2023', user_id: user.id}}

  #   post '/api/v1/promotions', params: promotion
  #   body = JSON.parse(response.body, symbolize_names: true)

  #   assert_response :created
  #   assert_equal promotion.name, body[:name]
  # end
end
