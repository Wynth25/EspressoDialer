class SessionsController < ApplicationController
  def new
    # Renders a simple login form
  end

  def create
    # Check if password matches your secret portfolio password
    if params[:password] == ENV['PORTFOLIO_ADMIN_PASSWORD']
      cookies.permanent.signed[:admin_authenticated] = true
      redirect_to root_path, notice: "Logged into personal database."
    else
      flash.now[:alert] = "Invalid password"
      render :new, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:admin_authenticated)
    redirect_to root_path, notice: "Logged out to public sandbox."
  end
end