class RenameImageUrlFromCocktails < ActiveRecord::Migration[5.2]
  def change
    rename_column :cocktails, :image_url, :image
  end
end
