# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin     = users(:admin)
        @category  = categories(:one)
      end

      test 'guest is redirected to root' do
        get admin_categories_url
        assert_redirected_to root_url
      end

      test 'non-admin is redirected to root' do
        sign_in users(:user)
        get admin_categories_url
        assert_redirected_to root_url
      end

      test 'GET /admin/categories as admin succeeds' do
        sign_in @admin
        get admin_categories_url
        assert_response :success
      end

      test 'GET /admin/categories/:id as admin succeeds' do
        sign_in @admin
        get admin_category_url(@category)
        assert_response :success
      end

      test 'GET /admin/categories/new as admin succeeds' do
        sign_in @admin
        get new_admin_category_url
        assert_response :success
      end

      test 'POST /admin/categories creates with valid params' do
        sign_in @admin
        assert_difference('Category.count', 1) do
          post admin_categories_url, params: { category: { name: "Cat_#{SecureRandom.hex(4)}" } }
        end
        created = Category.order(:id).last
        assert_redirected_to admin_category_url(created)
      end

      test 'POST /admin/categories does not create with invalid params' do
        sign_in @admin
        assert_no_difference('Category.count') do
          post admin_categories_url, params: { category: { name: '' } }
        end
        assert_equal 422, response.status
      end

      test 'GET /admin/categories/:id/edit as admin succeeds' do
        sign_in @admin
        get edit_admin_category_url(@category)
        assert_response :success
      end

      test 'PATCH /admin/categories/:id updates with valid params' do
        sign_in @admin
        patch admin_category_url(@category), params: { category: { name: 'UpdatedCat' } }
        assert_redirected_to admin_category_url(@category)
        assert_equal 'UpdatedCat', @category.reload.name
      end

      test 'PATCH /admin/categories/:id does not update with invalid params' do
        sign_in @admin
        old_name = @category.name
        patch admin_category_url(@category), params: { category: { name: '' } }
        assert_equal 422, response.status
        assert_equal old_name, @category.reload.name
      end

      test 'DELETE /admin/categories/:id destroys category' do
        sign_in @admin
        cat = Category.create!(name: 'Tmp_test')
        assert_difference('Category.count', -1) do
          delete admin_category_url(cat)
        end
        assert_not Category.exists?(name: 'Tmp_test')
        assert_redirected_to admin_categories_url
      end
    end
  end
end
