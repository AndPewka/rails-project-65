# frozen_string_literal: true

class AddStateToBulletin < ActiveRecord::Migration[7.2]
  def change
    add_column :bulletins, :state, :string
  end
end
