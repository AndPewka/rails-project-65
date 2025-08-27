# frozen_string_literal: true

class ChangeParamsStateToBulletin < ActiveRecord::Migration[7.2]
  def up
    change_column_default :bulletins, :state, from: nil, to: 'draft'
    change_column_null :bulletins, :state, false, 'draft'
    add_index :bulletins, :state
  end

  def down
    remove_index :bulletins, :state
    change_column_null :bulletins, :state, true
    change_column_default :bulletins, :state, from: 'draft', to: nil
  end
end
