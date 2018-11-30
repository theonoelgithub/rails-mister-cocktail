class AddTypeToCocktails < ActiveRecord::Migration[5.2]
  def change
    add_reference :cocktails, :type, foreign_key: true
  end
end
