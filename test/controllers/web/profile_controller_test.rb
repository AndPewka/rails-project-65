# frozen_string_literal: true

require 'test_helper'

module Web
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    setup { @user = users(:user) }

    test 'requires login' do
      get profile_url
      assert_redirected_to root_url
    end

    test 'shows own bulletins and supports simple search' do
      sign_in(@user)
      get profile_url
      assert_response :success
      assert_match 'Мои объявления', response.body

      get profile_url, params: { q: { title_cont: 'My' } }
      assert_response :success
    end
  end
end
