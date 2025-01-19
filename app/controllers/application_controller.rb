class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :redirect_to_root_if_session_expired

  private

  def redirect_to_root_if_session_expired
    return unless authenticated? && session_expired?
    terminate_session
    clear_site_data
    redirect_to new_session_path, alert: "Session expired. Please login again."
  end
end
