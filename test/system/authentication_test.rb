require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up ' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'E-mail', with: 'one.email@iugu.com.br'
    # fill_in 'Confirmar E-mail', with: 'one.email@iugu.com.br'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirmação de senha', with: '123456'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas vindas! Cadastrou e entrou com sucesso'
    assert_text 'one.email@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'user sign in' do
    user = User.create!(email: 'testeruser@iugu.com.br', password: '123456')

    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'

    assert_text 'Login efetuado com sucesso!'
    assert_text user.email
    assert_current_path root_path
    assert_link 'Sair'
    assert_no_link 'Entrar'
  end

  # TODO: password and email should not be blank
  # TODO: Teste de sair
  # TODO: Teste de falha ao registrar
  # TODO: Teste de falha ao logar
  # TODO: Teste o recuperar senha
  # TODO: Teste o editar o usuário
  # TODO: I18n do user
  # TODO: incluir name no user
end
