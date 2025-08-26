# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        @category = categories(:one)
      end

      test 'requires admin' do
        get admin_categories_url
        assert_redirected_to root_url
      end

      test 'full CRUD' do
        sign_in(@admin)

        get admin_categories_url
        assert_response :success

        get new_admin_category_url
        assert_response :success

        assert_difference('Category.count') do
          post admin_categories_url, params: { category: { name: 'NewCat' } }
        end
        c = Category.order(:id).last
        assert_redirected_to admin_category_url(c)

        get edit_admin_category_url(c)
        assert_response :success

        patch admin_category_url(c), params: { category: { name: 'UpdatedCat' } }
        assert_redirected_to admin_category_url(c)
        assert_equal 'UpdatedCat', c.reload.name

        assert_difference('Category.count', -1) do
          delete admin_category_url(c)
        end
        assert_redirected_to admin_categories_url
      end
    end
  end
end
