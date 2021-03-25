require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up ' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'E-mail', with: 'one.email@iugu.com.br'
    #fill_in 'Confirmar E-mail', with: 'one.email@iugu.com.br'
    fill_in 'Senha', with: '123'
    click_on 'Concluir'

    assert_text 'Boas vindas!'
    assert_text 'one.email@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

end