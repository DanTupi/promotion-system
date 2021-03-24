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

  test 'edit Product Category' do
    ProductCategory.create!(name: 'Livro', code: 'LIVR')
  
  visit root_path
  click_on 'Categorias de Produtos'
  click_on 'Livro'
  click_on 'Editar Categoria'
  
  fill_in 'Nome', with: 'Fogão'
  fill_in 'Código', with: 'FOG'
  click_on 'Enviar'

  assert_text 'Categoria editada com sucesso'
  assert_text 'Fogão'
  assert_text 'FOG'
  end

  test 'to edit a product category, it must be valid'  do
    ProductCategory.create!(name: 'Livro', code: 'LIVR')
  
  visit root_path
  click_on 'Categorias de Produtos'
  click_on 'Livro'
  click_on 'Editar Categoria'
  
  fill_in 'Nome', with: ''
  fill_in 'Código', with: ''
  click_on 'Enviar'

  assert_text 'não pode ficar em branco', count: 2
  end

  test 'can delete product category' do
    product_category = ProductCategory.create!(name: 'Caneta', code: 'CANET')
    
  visit product_category_path(product_category)
  click_on "Excluir Categoria"
  page.driver.browser.switch_to.alert.accept

  assert_current_path product_categories_path
  assert_no_text 'Caneta'
  assert_no_text 'CANET'
  end


end


