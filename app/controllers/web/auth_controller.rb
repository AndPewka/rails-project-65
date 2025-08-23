module Web
  class AuthController < ApplicationController
    def auth_request
      redirect_to "/auth/#{params[:provider]}"
    end

    def callback
      auth = OmniAuth.config.mock_auth[:github] || request.env['omniauth.auth']

      user = User.find_or_initialize_by(email: auth[:info][:email].downcase)
      user.name ||= auth[:info][:name]
      user.save!

      session[:user_id] = user.id
      redirect_to '/', notice: 'Signed in'
    end
  end
end
