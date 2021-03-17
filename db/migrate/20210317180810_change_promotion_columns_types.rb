class ChangePromotionColumnsTypes < ActiveRecord::Migration[6.1]
  def change
    change_column  :promotions, :discount_rate, :decimal
    change_column  :promotions, :expiration_date, :date

  end
end
