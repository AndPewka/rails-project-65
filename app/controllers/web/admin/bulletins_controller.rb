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
          redirect_back fallback_location: admin_bulletins_path, notice: t('admin.bulletins.flash.to_moderate.ok')
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: t('admin.bulletins.flash.to_moderate.forbidden', state: @bulletin.state)
        end
      end

      def publish
        if @bulletin.may_publish?
          @bulletin.publish!
          redirect_back fallback_location: admin_bulletins_path, notice: t('admin.bulletins.flash.publish.ok')
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: t('admin.bulletins.flash.publish.forbidden', state: @bulletin.state)
        end
      end

      def reject
        if @bulletin.may_reject?
          @bulletin.reject!
          redirect_back fallback_location: admin_bulletins_path, notice: t('admin.bulletins.flash.reject.ok')
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: t('admin.bulletins.flash.reject.forbidden', state: @bulletin.state)
        end
      end

      def archive
        if @bulletin.may_archive?
          @bulletin.archive!
          redirect_back fallback_location: admin_bulletins_path, notice: t('admin.bulletins.flash.archive.ok')
        else
          redirect_back fallback_location: admin_bulletins_path,
                        alert: t('admin.bulletins.flash.archive.forbidden', state: @bulletin.state)
        end
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end

      def require_admin!
        redirect_to root_path, alert: t('alerts.forbidden') unless current_user&.admin?
      end
    end
  end
end
