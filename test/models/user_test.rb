# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'validations' do
    u = User.new
    assert_not u.valid?
    u.email = 'x@example.com'
    u.name  = 'X'
    assert u.valid?
  end

  test 'has many bulletins assoc' do
    assert_respond_to User.new, :bulletins
  end
end
