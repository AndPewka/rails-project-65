# frozen_string_literal: true

class ChangeParamsStateToBulletin < ActiveRecord::Migration[7.2]
  def up
    Bulletin.where(state: nil).update_all(state: 'draft')
    change_column :bulletins, :state, :string, null: false, default: 'draft'
    add_index :bulletins, :state
  end

  def down
    remove_index :bulletins, :state
    change_column :bulletins, :state, :string, null: true, default: nil
  end
end
