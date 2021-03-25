require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')
    user = User.create!(email: 'usertester@iugu.com.br', password: '123456')

    login_as user, scope: :user
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar para Promoções'

    assert_current_path promotions_path
  end

  test 'create promotion' do
      visit root_path
      click_on 'Promoções'
      click_on 'Registrar uma promoção'
      fill_in 'Nome', with: 'Cyber Monday'
      fill_in 'Descrição', with: 'Promoção de Cyber Monday'
      fill_in 'Código', with: 'CYBER15'
      fill_in 'Desconto', with: '15'
      fill_in 'Quantidade de cupons', with: '90'
      fill_in 'Data de término', with: '22/12/2033'
      click_on 'Criar Promoção'
  
      assert_current_path promotion_path(Promotion.last)
      assert_text 'Cyber Monday'
      assert_text 'Promoção de Cyber Monday'
      assert_text '15,00%'
      assert_text 'CYBER15'
      assert_text '22/12/2033'
      assert_text '90'
      assert_link 'Voltar'
    end

    test 'create and attributes cannot be blank' do
      visit root_path
      click_on 'Promoções'
      click_on 'Registrar uma promoção'
      click_on 'Criar Promoção'
  
      assert_text 'não pode ficar em branco', count: 5
    end
  
    test 'create and code/name must be unique' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')
  
      visit root_path
      click_on 'Promoções'
      click_on 'Registrar uma promoção'
      fill_in 'Código', with: 'NATAL10'
      fill_in 'Nome', with: 'Natal'
      click_on 'Criar Promoção'
  
      assert_text 'já está em uso'
    end

    test 'generate coupons! succesfully' do
      promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100, 
                                  expiration_date: '22/12/2033')
      visit promotion_path(promotion)
      click_on 'Gerar cupons'

      assert_text 'Cupons gerados com sucesso'
      assert_no_link 'Gerar cupons'
      assert_no_text 'NATAL10-0000'
      assert_text 'NATAL10-0001 (ativo)'
      assert_text 'NATAL10-0002 (ativo)'
      assert_text 'NATAL10-0100 (ativo)'
      assert_no_text 'NATAL10-0101'
      assert_link 'Desabilitar', count: 100
    end

    test 'edit promotion' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')
    
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar Promoção'
    
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Enviar'

    assert_text 'Promoção editada com sucesso'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    end

    test 'to edit a promotion, it must be valid'  do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')
    
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Editar Promoção'
    
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Enviar'

    assert_text 'não pode ficar em branco', count: 5
    end

    test 'can delete promotion' do
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
        expiration_date: '22/12/2033')
      
    visit promotion_path(promotion)
    click_on "Excluir Promoção"
    page.driver.browser.switch_to.alert.accept

    assert_current_path promotions_path
    assert_no_text 'Natal'
    assert_no_text 'Promoção de Natal'
    end

    test 'do not view promotion link without login' do
      visit root_path

      assert_no_link 'Promoções'
    end
    
  # TODO: several authentication inserts on tests
end
