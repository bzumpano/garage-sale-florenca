class RenameTitleToNameInProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :title, :name
  end
end
