class RecipesController < ApplicationController
  # We added :quick_log here so it automatically runs set_recipe for your buttons
  before_action :set_recipe, only: %i[ show edit update destroy quick_log ]

  def index
    @beans = Bean.includes(:recipes).all
  end

  def show
  end

  def new
    @recipe = Recipe.new
  end

  def edit
  end

  # Your custom create method that saves the Recipe and the first Brew
  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      @recipe.brews.create!(
        dose: params[:initial_dose],
        grind: params[:initial_grind]
      )
      redirect_to root_path, notice: "Recipe created and dialed in!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # The standard update method that was missing
  def update
    if @recipe.update(recipe_params)
      redirect_to recipe_url(@recipe), notice: "Recipe was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_url, notice: "Recipe was successfully destroyed."
  end

  def quick_log
    # Grab the final numbers from the form submission
    new_dose = params[:dose].to_f.round(1)
    new_grind = params[:grind].to_f.round(1)

    # Save the history
    @recipe.brews.create!(dose: new_dose, grind: new_grind)
    
    # Send the user back to the dashboard instead of updating the frame
    redirect_to root_path, notice: "Brew successfully logged!"
  end

  private
    # This is the method the before_action is calling
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Strong parameters
    def recipe_params
      params.require(:recipe).permit(:bean_id, :basket_id, :style, :target_ratio)
    end
end