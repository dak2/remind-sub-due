class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :redirect_to_root_if_logged_in, only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.find_or_initialize_by(uid: auth_hash["uid"])

    if user.new_record?
      user.email_address = auth_hash["info"]["email"]
      user.name = auth_hash["info"]["name"]
      user.save
      start_new_session_for user
      redirect_to after_authentication_url
    end

    if user.email_address != auth_hash["info"]["email"]
      user.email_address = auth_hash["info"]["email"]
      user.save
    end

    start_new_session_for user
    redirect_to after_authentication_url
  rescue => e
    Rails.logger.error "error: #{e.message}"
    redirect_to new_session_path, alert: "Try again later."
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end

  private
    def auth_hash
      request.env["omniauth.auth"]
    end

    def redirect_to_root_if_logged_in
      redirect_to after_authentication_url if authenticated?
    end
end
