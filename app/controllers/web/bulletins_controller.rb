# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :set_bulletin, only: %i[show edit update destroy to_moderate archive]
    before_action :require_user!, only: %i[new create]
    before_action :require_owner!, only: %i[edit update destroy to_moderate archive]

    def index
      @q = Bulletin.published.includes(:category).ransack(params[:q])
      @bulletins = @q.result.order(created_at: :desc).page(params[:page])
    end

    def show; end

    def new
      @bulletin = current_user.bulletins.build
    end

    def create
      @bulletin = current_user.bulletins.build(bulletin_params)
      if @bulletin.save
        redirect_to profile_path, notice: 'Объявление создано'
      else
        flash.now[:alert] = 'Не удалось создать объявление'
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @bulletin.update(bulletin_params)
        redirect_to @bulletin, notice: 'Объявление обновлено'
      else
        flash.now[:alert] = 'Не удалось обновить объявление'
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @bulletin.destroy
      redirect_to profile_path, notice: 'Объявление удалено'
    end

    # FSM (автор)
    def to_moderate
      @bulletin.to_moderate! if @bulletin.may_to_moderate?
      redirect_back fallback_location: profile_path, notice: 'Отправлено на модерацию'
    end

    def archive
      @bulletin.archive! if @bulletin.may_archive?
      redirect_back fallback_location: profile_path, notice: 'Отправлено в архив'
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end

    def require_owner!
      require_user!
      redirect_to root_path, alert: 'Доступ запрещён' unless @bulletin.user_id == current_user.id
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
