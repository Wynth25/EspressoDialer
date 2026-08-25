class SessionsController < ApplicationController
  def new
  end

  def create
    # Extract any possible password param (flat, nested, or form-scoped)
    submitted_password = params[:password] || 
                         params.dig(:session, :password) || 
                         params.values.find { |v| v.is_a?(Hash) && v[:password] }&.dig(:password)
    
    expected_password = ENV["ADMIN_PASSWORD"]

    # DIAGNOSTIC 1: Is Render passing the ENV variable to Rails?
    if expected_password.blank?
      flash.now[:alert] = "DEBUG: ENV['ADMIN_PASSWORD'] is empty or not loaded on Render."
      return render :new, status: :unprocessable_entity
    end

    # DIAGNOSTIC 2: Did Rails receive the input from the form?
    if submitted_password.blank?
      flash.now[:alert] = "DEBUG: Form did not send a password parameter. Received params: #{params.to_unsafe_h.except('authenticity_token', 'controller', 'action')}"
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