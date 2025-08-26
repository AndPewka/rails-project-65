# frozen_string_literal: true

module Web
  class ProfileController < ApplicationController
    before_action :require_user!

    def show
      @q = current_user.bulletins.includes(:category).ransack(params[:q])
      @bulletins = @q.result.order(created_at: :desc).page(params[:page])
    end
  end
end
