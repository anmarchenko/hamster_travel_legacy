# frozen_string_literal: true
class AddDefaultValueToDatesUnknown < ActiveRecord::Migration[5.0]
  def change
    change_column :trips, :dates_unknown, :boolean, default: false
  end
end
