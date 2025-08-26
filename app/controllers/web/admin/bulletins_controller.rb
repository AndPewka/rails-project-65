# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :require_admin!
      before_action :set_bulletin, only: %i[show publish reject archive]

      def moderation
        @q = Bulletin.under_moderation.ransack(params[:q])
        @bulletins = @q.result.includes(:user, :category).order(created_at: :desc).page(params[:page])
      end

      def index
        @q = Bulletin.ransack(params[:q])
        @bulletins = @q.result.includes(:user, :category).order(created_at: :desc).page(params[:page])
      end

      def show; end

      def to_moderate
        if @bulletin.may_to_moderate?
          @bulletin.to_moderate!
          redirect_back fallback_location: admin_bulletins_path, notice: 'Переведено на модерацию'
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: "Нельзя перевести из состояния #{@bulletin.state}"
        end
      end

      def publish
        if @bulletin.may_publish?
          @bulletin.publish!
          redirect_back fallback_location: admin_bulletins_path, notice: 'Опубликовано'
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: "Публикация недоступна из состояния #{@bulletin.state}. Сначала отправьте на модерацию."
        end
      end

      def reject
        if @bulletin.may_reject?
          @bulletin.reject!
          redirect_back fallback_location: admin_bulletins_path, notice: 'Отклонено'
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: "Отклонение недоступно из состояния #{@bulletin.state}"
        end
      end

      def archive
        if @bulletin.may_archive?
          @bulletin.archive!
          redirect_back fallback_location: admin_bulletins_path, notice: 'В архиве'
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: "Архивирование недоступно из состояния #{@bulletin.state}"
        end
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end

      def require_admin!
        redirect_to root_path, alert: 'Доступ запрещён' unless current_user&.admin?
      end
    end
  end
end
