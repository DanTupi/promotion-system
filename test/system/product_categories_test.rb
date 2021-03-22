require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase

  test 'no product categories are available' do
    visit root_path
    click_on 'Categorias de Produtos'

    assert_text 'Nenhuma Categoria de Produto cadastrada'
  end

  test 'view product_categories' do
    ProductCategory.create!(name: 'Carro', code: 'CARRO')
    ProductCategory.create!(name: 'Computador', code: 'CPU')

    visit root_path
    click_on 'Categorias de Produtos'

    assert_text 'Carro'
    assert_text 'CARRO'
    assert_text 'Computador'
    assert_text 'CPU'
  end

  test 'view product categories and return to home page' do
    ProductCategory.create!(name: 'Carro', code: 'CARRO')

    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'create product category' do
    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Registrar uma Categoria de Produtos'
    fill_in 'Nome', with: 'Panela'
    fill_in 'Código', with: 'PAN'
    click_on 'Criar Categoria'

    assert_current_path product_category_path(ProductCategory.last)
    assert_text 'Panela'
    assert_text 'PAN'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Registrar uma Categoria'
    click_on 'Criar Categoria'

    assert_text 'não pode ficar em branco', count: 2
  end

  test 'create and code/name must be unique' do
    ProductCategory.create!(name: 'Livro', code: 'LIVR')

    visit root_path
    click_on 'Categorias de Produtos'
    click_on 'Registrar uma Categoria'
    fill_in 'Nome', with: 'Livro'
    fill_in 'Código', with: 'LIVR'
    click_on 'Criar Categoria'

    assert_text 'deve ser único'
  end




end


