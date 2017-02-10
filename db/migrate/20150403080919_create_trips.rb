# frozen_string_literal: true
class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.text :short_description

      t.date :start_date
      t.date :end_date

      t.boolean :archived, default: false

      t.text :comment

      t.integer :budget_for, default: 1

      t.boolean :private, default: false

      t.string :image_uid

      t.string :status_code, default: Travels::Trip::StatusCodes::DRAFT

      t.belongs_to :author_user, index: true

      t.string :mongo_id

      t.timestamp :updated_at
      t.timestamp :created_at
    end

    create_table :users_trips, id: false do |t|
      t.belongs_to :trip, index: true
      t.belongs_to :user, index: true
    end
  end
end
