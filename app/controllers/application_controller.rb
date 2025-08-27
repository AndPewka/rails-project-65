# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  helper_method :current_user

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: t('alerts.not_authorized')
  end

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def require_user!
    return if current_user

    redirect_to root_path, alert: t('alerts.sign_in_required')
  end

  def require_admin!
    redirect_to root_path, alert: t('alerts.forbidden') unless current_user&.admin?
  end
end
