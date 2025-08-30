# frozen_string_literal: true

class AddUniqueIndexToUsersEmail < ActiveRecord::Migration[7.2]
  def up
    add_index :users, :email, unique: true
  end

  def down
    remove_index :users, :email
  end
end
