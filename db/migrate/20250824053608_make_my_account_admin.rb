# frozen_string_literal: true

class MakeMyAccountAdmin < ActiveRecord::Migration[7.2]
  def up
    user = User.find_by(email: 'andpewka@outlook.com')
    user&.update!(admin: true)
  end

  def down
    user = User.find_by(email: 'andpewka@outlook.com')
    user&.update!(admin: false)
  end
end
