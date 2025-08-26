# frozen_string_literal: true

require 'test_helper'

class BulletinTest < ActiveSupport::TestCase
  setup do
    @user = users(:user)
    @category = categories(:one)
  end

  test 'valid with image/title/description/category/user' do
    b = Bulletin.new(
      title: 'Hello',
      description: 'Long text',
      user: @user,
      category: @category
    )
    b.image.attach(io: File.open(file_fixture('test.png')), filename: 'test.png', content_type: 'image/png')
    assert b.valid?
  end

  test 'title and description presence/length' do
    b = Bulletin.new
    refute b.valid?
    b.title = 'x' * 51
    b.description = 'y' * 1001
    b.user = @user
    b.category = @category
    b.image = nil
    refute b.valid?
  end

  test 'fsm transitions' do
    b = bulletins(:draft_user_own)
    attach_test_image!(b)

    b.to_moderate!
    assert_equal 'under_moderation', b.reload.state

    b.publish!
    assert_equal 'published', b.reload.state

    b.archive!
    assert_equal 'archived', b.reload.state
  end

  test 'scopes' do
    b_pub = bulletins(:published_other)
    attach_test_image!(b_pub)

    assert_includes Bulletin.published, b_pub
    assert_not_includes Bulletin.published, bulletins(:draft_user_own)
  end
end
