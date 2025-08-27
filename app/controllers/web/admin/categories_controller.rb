# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show edit update destroy]

      def index
        @categories = Category.order(:id)
      end

      def show; end

      def new
        @category = Category.new
      end

      def edit; end

      def create
        @category = Category.new(category_params)
        if @category.save
          redirect_to admin_category_path(@category), notice: t('categories.created')
        else
          flash.now[:alert] = t('categories.create_failed')
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          redirect_to admin_category_path(@category), notice: t('categories.updated')
        else
          flash.now[:alert] = t('categories.update_failed')
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @category.destroy
        redirect_to admin_categories_path, notice: t('categories.deleted')
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
