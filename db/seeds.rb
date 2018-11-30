# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

p "on nettoie les ingrédients parce que l'hygiene c'est important"
Ingredient.destroy_all

p "et c'est parti pour le seed"
url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"

ingredients = open(url).read
JSON.parse(ingredients)['drinks'].each do |hash|
  Ingredient.create!(name: hash["strIngredient1"].downcase.capitalize)
end
p "et c'est fini, #{Ingredient.count} ingrédients chargés"

p "on crée les types de cocktail"
["Alcoholic", "Non alcoholic", "Optional alcohol"].each do |type|
  Type.create!(name: type)
end
p "#{Type.count} types chargés"

p 'on attaque les cocktails maintenant'

50.times do
  url = 'https://www.thecocktaildb.com/api/json/v1/1/random.php'
  result = JSON.parse(open(url).read)['drinks'][0]
  # p result
  # p result['strDrink'].strip.downcase.capitalize
  if Cocktail.find_by(name: result['strDrink'].strip.downcase.capitalize).nil?
    type = Type.find_by(name: result['strAlcoholic'])
    instructions = result["strInstructions"]
    cocktail_new = Cocktail.new(name: result['strDrink'].strip.downcase.capitalize, image_url: result['strDrinkThumb'], type: type, instructions: instructions)
    cocktail_new.save!
    i = 1
    ingredient = result["strIngredient#{i}"].strip.chomp.downcase.capitalize
    until ingredient.empty?
      new_ingr = Ingredient.find_by(name: ingredient)
      new_ingr = Ingredient.create!(name: result["strIngredient#{i}"].chomp.capitalize) if new_ingr.nil?
      if result["strMeasure#{i}"].strip.chomp.empty?
        description_new = 'up to you'
      else
        description_new = result["strMeasure#{i}"]
      end
      Dose.create(description: description_new, cocktail: cocktail_new, ingredient: new_ingr)
      i += 1
      result["strIngredient#{i}"].nil? ? ingredient = "" : ingredient = result["strIngredient#{i}"].strip.chomp.downcase.capitalize
    end
  end
  next
end
p "au top, on a maintenant #{Cocktail.count} cocktails en base et #{Dose.count} doses crées"
