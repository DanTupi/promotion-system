class AddUserReferencesToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_reference :promotions, :user, null: false, foreign_key: true
  end
end
