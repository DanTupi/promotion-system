require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'no product categories are available' do
    get '/api/v1/product_categories/0', as: :json

    assert_response :not_found
  end

  test 'show all product_categories' do
    p_category_01 = ProductCategory.create!(name: 'Carro', code: 'CARRO')
    p_category_02 = ProductCategory.create!(name: 'Computador', code: 'CPU')

    get api_v1_product_categories_path, as: :json
    
    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal p_category_01.name, body.first[:name]
    assert_equal p_category_02.name, body.last[:name]
  end
end