# frozen_string_literal: true
require 'test_helper'

class BulletinPolicyTest < ActiveSupport::TestCase
  def setup
    @owner = users(:user)
    @admin = users(:admin)
    @own_draft = bulletins(:draft_user_own)
    attach_test_image!(@own_draft)
  end

  test 'scope returns only published for guest' do
    records = Pundit.policy_scope!(nil, Bulletin)
    assert records.all? { |b| b.state == 'published' }
  end

  test 'show allowed for published for guest' do
    policy = BulletinPolicy.new(nil, bulletins(:published_other))
    assert policy.show?
  end

  test 'create allowed for logged user' do
    policy = BulletinPolicy.new(@owner, Bulletin.new)
    assert policy.create?
  end

  test 'update/destroy allowed only for owner or admin' do
    owner_policy = BulletinPolicy.new(@owner, @own_draft)
    admin_policy = BulletinPolicy.new(@admin, @own_draft)
    assert owner_policy.update?
    assert owner_policy.destroy?
    assert admin_policy.update?
    assert admin_policy.destroy?
  end
end
