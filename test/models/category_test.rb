# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'name presence' do
    c = Category.new
    refute c.valid?
    c.name = 'Stuff'
    assert c.valid?
  end
end
