# frozen_string_literal: true

require 'test_helper'

module Web
  class BulletinsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user      = users(:user)
      @published = bulletins(:published_other)
      @own_draft = bulletins(:draft_user_own)
      attach_test_image!(@own_draft)
    end

    test 'GET / shows only published' do
      get bulletins_url
      assert_response :success
      assert_match @published.title, response.body
      assert_no_match @own_draft.title, response.body
    end

    test 'GET /bulletins/:id does not render admin sidebar' do
      get bulletin_url(@published)
      assert_response :success
      assert_no_match 'Объявления на модерации', response.body
      assert_no_match 'Все категории', response.body
    end

    test 'POST /bulletins requires login' do
      post bulletins_url, params: { bulletin: { title: 'X', description: 'Y', category_id: categories(:one).id } }
      assert_redirected_to root_url
    end

    test 'POST /bulletins with image creates for signed user' do
      sign_in(@user)

      file = Rack::Test::UploadedFile.new(file_fixture('test.png'), 'image/png')
      assert_difference('Bulletin.count') do
        post bulletins_url, params: {
          bulletin: {
            title: 'Created',
            description: 'Descr',
            category_id: categories(:one).id,
            image: file
          }
        }
      end
      assert_redirected_to profile_url
    end

    test 'PATCH to_moderate by owner' do
      sign_in(@user)
      patch to_moderate_bulletin_url(@own_draft)
      assert_redirected_to profile_url
      assert_equal 'under_moderation', @own_draft.reload.state
    end

    test 'PATCH archive by owner' do
      sign_in(@user)
      patch archive_bulletin_url(@own_draft)
      assert_redirected_to profile_url
      assert_equal 'archived', @own_draft.reload.state
    end
  end
end
