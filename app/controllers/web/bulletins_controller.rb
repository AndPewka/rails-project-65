# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :require_login, only: %i[new create edit update]
    before_action :set_bulletin, only: %i[show edit update]

    def index
      @bulletins = Bulletin.order(created_at: :desc)
    end

    def show; end

    def new
      @bulletin = Bulletin.new
    end

    def create
      @bulletin = current_user.bulletins.build(bulletin_params)
      if @bulletin.save
        redirect_to root_path, notice: 'Bulletin created successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @bulletin.update(bulletin_params)
        redirect_to @bulletin, notice: 'Bulletin updated successfully'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end

    def require_login
      redirect_to root_path, alert: 'You must be logged in' unless current_user
    end
  end
end
