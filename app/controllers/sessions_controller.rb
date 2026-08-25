class SessionsController < ApplicationController
  def create
    if params[:password] == ENV["ADMIN_PASSWORD"]
      session[:admin_id] = "admin_authorized"
      redirect_to root_path, notice: "Logged into Admin mode."
    else
      flash.now[:alert] = "Incorrect password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path, notice: "Logged out. Switched to Sandbox mode."
  end
end