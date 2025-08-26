# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_user!
    return if current_user

    redirect_to root_path, alert: 'Войдите в систему' and return
  end

  def require_admin!
    redirect_to root_path, alert: 'Доступ запрещён' unless current_user&.admin?
  end
end
