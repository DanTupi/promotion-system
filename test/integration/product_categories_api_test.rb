require 'test_helper'

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'no product categories are available' do
    get '/api/v1/product_categories/0', as: :json

    assert_response :not_found
  end

  test 'show all product_categories' do
    first_p_category = ProductCategory.create!(name: 'Carro', code: 'CARRO')
    second_p_category = ProductCategory.create!(name: 'Computador', code: 'CPU')

    get api_v1_product_categories_path, as: :json

    assert_response :success
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal first_p_category.name, body.first[:name]
    assert_equal second_p_category.name, body.last[:name]
  end
end
