# frozen_string_literal: true

require 'test_helper'

module Web
  module Admin
    class BulletinsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @admin = users(:admin)
        @mod   = bulletins(:moderation_other)
        attach_test_image!(@mod)           # ← важно: чтобы publish/reject/archive прошли валидации
      end

      test 'requires admin' do
        get admin_bulletins_url
        assert_redirected_to root_url
      end

      test 'moderation and index render for admin' do
        sign_in(@admin)
        get moderation_admin_bulletins_url
        assert_response :success
        get admin_bulletins_url
        assert_response :success
      end

      test 'publish' do
        sign_in(@admin)
        patch publish_admin_bulletin_url(@mod)
        assert_redirected_to admin_bulletins_url
        assert_equal 'published', @mod.reload.state
      end

      test 'reject' do
        sign_in(@admin)
        @mod.update!(state: 'under_moderation') # на всякий случай, если порядок тестов изменится
        patch reject_admin_bulletin_url(@mod)
        assert_redirected_to admin_bulletins_url
        assert_equal 'rejected', @mod.reload.state
      end

      test 'archive' do
        sign_in(@admin)
        patch archive_admin_bulletin_url(@mod)
        assert_redirected_to admin_bulletins_url
        assert_equal 'archived', @mod.reload.state
      end
    end
  end
end
