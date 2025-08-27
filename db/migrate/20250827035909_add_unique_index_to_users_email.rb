# frozen_string_literal: true

class AddUniqueIndexToUsersEmail < ActiveRecord::Migration[7.2]
  def change
    add_index :users, :email, unique: true unless index_exists?(:users, :email, unique: true)
  end
end
