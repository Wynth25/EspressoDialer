class BeansController < ApplicationController
  before_action :set_bean, only: %i[ show edit update destroy ]

  # GET /beans or /beans.json
  def index
    @beans = Bean.all
  end

  # GET /beans/1 or /beans/1.json
  def show
  end

  # GET /beans/new
  def new
    @bean = Bean.new
  end

  # GET /beans/1/edit
  def edit
  end

  # POST /beans or /beans.json
  def create
    @bean = Bean.new(bean_params)

    respond_to do |format|
      if @bean.save
        format.html { redirect_to @bean, notice: "Bean was successfully created." }
        format.json { render :show, status: :created, location: @bean }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @bean.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /beans/1 or /beans/1.json
  def update
    respond_to do |format|
      if @bean.update(bean_params)
        format.html { redirect_to @bean, notice: "Bean was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @bean }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @bean.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /beans/1 or /beans/1.json
  def destroy
    @bean.destroy!

    respond_to do |format|
      format.html { redirect_to beans_path, notice: "Bean was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bean
      @bean = Bean.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bean_params
      params.expect(bean: [ :roastery, :name, :description, :notes, :roast_date, :frozen_on ])
    end
end
