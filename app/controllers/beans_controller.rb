class BeansController < ApplicationController
  before_action :set_bean, only: %i[ show edit update destroy ]

  # GET /beans or /beans.json
  def index
    @beans = Bean.all.order(created_at: :desc)
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


  def create
      @bean = Bean.new(bean_params)

      respond_to do |format|
        if @bean.save
          format.html { redirect_to beans_path, notice: "Bean was successfully created." }
          format.json { render :show, status: :created, location: @bean }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @bean.errors, status: :unprocessable_content }
        end
      end
    end

  def update
    respond_to do |format|
      if @bean.update(bean_params)
        # Using redirect_back safely returns you to the index page, even if edited from elsewhere
        format.html { redirect_back fallback_location: beans_path, notice: "Bean was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @bean }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @bean.errors, status: :unprocessable_content }
      end
    end
  end

  def archive
    @bean = Bean.find(params[:id])
    @bean.update(archived: true)
    redirect_to beans_path, notice: "Bean and its recipes were archived."
  end

  def archived
    @beans = Bean.where(archived: true)
  end

  def update_freeze
    @bean = Bean.find(params[:id])
    @bean.update(freeze_date: params[:freeze_date])
    redirect_to beans_path, notice: "Freeze date updated."
  end

  def destroy
    @bean.destroy!

    respond_to do |format|
      format.html { redirect_to beans_path, notice: "Bean was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def sort
    params[:bean_ids].each_with_index do |id, index|
      Bean.find(id).update(position: index + 1)
    end
    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bean
      @bean = Bean.find(params.expect(:id))
    end

    def bean_params
      params.require(:bean).permit(:name, :roastery, :roast_date, :description, :notes, :archived, :position, :frozen_on, :freeze_date)
    end
end
