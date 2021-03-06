class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Pundit - catch controller actions where we may have forgotten to call authorize
  # after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def hello
    # Nothing to see here...
  end

protected

   def configure_permitted_parameters
     devise_parameter_sanitizer.for(:sign_up) << :name
   end

private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
