class ApplicationController < ActionController::Base
  before_action :store_current_location, :unless => :devise_controller?
  protect_from_forgery with: :exception

  def require_is_admin
    if !current_user.admin?
      flash[:alert] = "You are not admin"
      redirect_to root_path

    end

  end

  private

  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

end
