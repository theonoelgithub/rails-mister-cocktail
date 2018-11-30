class CocktailsController < ApplicationController
  before_action :set_cocktail, only: :show

  def index
    @cocktails = Cocktail.all
    search = params["cocktailsearch"]
    type_search = params["type"]
    @cocktails = Type.find_by(name: type_search).cocktails unless type_search.nil? || type_search.empty?
    @cocktails = @cocktails.where("name LIKE ?", "%#{search}%") unless search.nil? || search.empty?
  end

  def show
    @review = Review.new
    @dose = Dose.new
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.create(set_params)
    if @cocktail.save
      redirect_to cocktail_path(@cocktail)
    else
      render :new
    end
  end

  private

  def set_cocktail
    @cocktail = Cocktail.find(params[:id])
  end

  def set_params
    params.require(:cocktail).permit(:name, :image, :type_id, :instructions)
  end
end
