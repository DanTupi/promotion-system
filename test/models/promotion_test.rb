require 'test_helper'

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    assert_not promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(code: 'NATAL10')

    assert_not promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test 'name must be uniq' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.new(name: 'Natal')

    assert_not promotion.valid?
    assert_includes promotion.errors[:name], 'já está em uso'
  end

  test '#generate_coupons! succesfully' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    promotion.generate_coupons!

    assert promotion.coupons.size == promotion.coupon_quantity
    assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test '#generate_coupons! cannot be called twice' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    Coupon.create!(code: '007', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test '.search by exact' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    christmas =  Promotion.create!(name: 'Natal',
                                   description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10,
                                   coupon_quantity: 100,
                                   expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)
    result = Promotion.search('Natal')
    assert_includes result, christmas
    assert_not_includes result, cyber_monday
  end

  test '.search by partial' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    christmas =  Promotion.create!(name: 'Natal',
                                   description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10,
                                   coupon_quantity: 100,
                                   expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)
    christmas_eve = Promotion.create!(name: 'Natalina',
                                      description: 'Noite de Natal',
                                      code: 'NATALINO10', discount_rate: 10,
                                      coupon_quantity: 100,
                                      expiration_date: '22/12/2033', user: user)
    result = Promotion.search('natal')
    assert_includes result, christmas
    assert_includes result, christmas_eve
    assert_not_includes result, cyber_monday
  end

  test '.search finds nothing' do
    user = User.create!(email: 'testolino@iugu.com.br', password: '123456')
    christmas =  Promotion.create!(name: 'Natal',
                                   description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10,
                                   coupon_quantity: 100,
                                   expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)
    result = Promotion.search('halloween')
    assert_empty result
    assert_not_includes result, christmas
    assert_not_includes result, cyber_monday
  end
end
