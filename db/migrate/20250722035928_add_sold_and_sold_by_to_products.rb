class AddSoldAndSoldByToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :sold, :boolean
    add_column :products, :sold_by, :integer
  end
end
