class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :related_link
      t.text :description
      t.string :title
      t.string :sub_title
      t.float :current_price
      t.float :previous_price

      t.timestamps
    end
  end
end
