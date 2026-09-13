class SessionsController < ApplicationController
  def new
  end

  def create
    # Extract any possible password param
    submitted_password = params[:password] || 
                         params.dig(:session, :password) || 
                         params.values.find { |v| v.is_a?(Hash) && v[:password] }&.dig(:password)
    
    expected_password = ENV["ADMIN_PASSWORD"]

    # DIAGNOSTIC 1: Is Docker passing the ENV variable?
    if expected_password.blank?
      flash.now[:alert] = "DEBUG: ENV['ADMIN_PASSWORD'] is empty or not loaded."
      return render :new, status: :unprocessable_entity
    end

    # DIAGNOSTIC 2: Did the form send data?
    if submitted_password.blank?
      flash.now[:alert] = "DEBUG: Form did not send a password parameter."
      return render :new, status: :unprocessable_entity
    end

    # DIAGNOSTIC 3: Password Comparison
    if submitted_password.to_s.strip == expected_password.to_s.strip
      session[:admin_id] = "admin_authorized"
      redirect_to root_path, notice: "Admin mode unlocked! (Session set)"
    else
      flash.now[:alert] = "DEBUG: Password mismatch. Submitted length: #{submitted_password.to_s.strip.length} chars, Expected length: #{expected_password.to_s.strip.length} chars."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to root_path, notice: "Logged out. Switched to Sandbox mode."
  end
end