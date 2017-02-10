# frozen_string_literal: true
class AddCitiesRefsToTransfers < ActiveRecord::Migration
  def change
    add_reference :transfers, :city_to, index: true
    add_reference :transfers, :city_from, index: true
  end
end
