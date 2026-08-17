class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[ show edit update destroy ]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1 or /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: "Recipe was successfully created." }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @recipe.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to @recipe, notice: "Recipe was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @recipe.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    @recipe.destroy!

    respond_to do |format|
      format.html { redirect_to recipes_path, notice: "Recipe was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.expect(recipe: [ :bean_id, :basket_id, :style, :target_ratio ])
    end
end

def quick_log
  @recipe = Recipe.find(params[:id])
  last_brew = @recipe.latest_brew
  
  # Start with the last known settings
  new_dose = last_brew.dose
  new_grind = last_brew.grind

  # Check if a dose button or manual input was submitted
  if params[:dose_adjustment].present?
    new_dose = (last_brew.dose + params[:dose_adjustment].to_f).round(1)
  elsif params[:manual_dose].present?
    new_dose = params[:manual_dose].to_f.round(1)
  end

  # Check if a grind button or manual input was submitted
  if params[:grind_adjustment].present?
    new_grind = (last_brew.grind + params[:grind_adjustment].to_f).round(1)
  elsif params[:manual_grind].present?
    new_grind = params[:manual_grind].to_f.round(1)
  end

  # Create the new historical record
  @recipe.brews.create!(dose: new_dose, grind: new_grind)

  render partial: "recipes/brew_controls", locals: { recipe: @recipe }
end