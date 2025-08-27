# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def auth_request
      redirect_to "/auth/#{params[:provider]}"
    end

    def callback
      auth = OmniAuth.config.mock_auth[:github] || request.env['omniauth.auth']

      user = User.find_or_initialize_by(email: auth[:info][:email].downcase)
      user.name ||= auth[:info][:name] || auth[:info][:nickname] || "User#{auth[:uid]}"
      user.save!

      session[:user_id] = user.id
      redirect_to '/', notice: t('auth.signed_in')
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: t('auth.signed_out')
    end
  end
end
