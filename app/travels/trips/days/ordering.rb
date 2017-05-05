# frozen_string_literal: true

module Trips
  module Days
    module Ordering
      def self.reorder(trip, ordered_ids, fields)
        return [:error, 'counts'] if trip.days.count != ordered_ids.count
        execute_plan(
          reordering_plan(trip, ordered_ids, fields)
        )
        :ok
      end

      # INTERNAL ACTIONS
      def self.reordering_plan(trip, ordered_ids, fields)
        current_ids = Trips::Days.list(trip).pluck(:id)
        ordered_ids.each_with_index.map do |source_id, index|
          {
            transferred_entities: transferred_entities(
              Trips::Days.by_id(trip, source_id),
              fields
            ),
            target_id: current_ids[index]
          }
        end
      end

      def self.execute_plan(reordering_plan)
        ActiveRecord::Base.transaction do
          reordering_plan.each do |operation|
            transfer(operation[:transferred_entities], operation[:target_id])
          end
        end
      end

      def self.transferred_entities(source_day, fields)
        fields.map do |requested_field|
          case requested_field
          when 'transfers'
            transferred_entities_for_transfers(source_day)
          when 'activities'
            transferred_entities_for_activities(source_day)
          when 'day_info'
            transferred_entities_for_day_info(source_day)
          end
        end.reduce(:merge)
      end

      def self.transferred_entities_for_transfers(source_day)
        {
          transfers: Trips::Transfers.list(source_day).pluck(:id),
          hotel: Trips::Hotels.by_day(source_day).id,
          places: Trips::Places.list(source_day).pluck(:id)
        }
      end

      def self.transferred_entities_for_activities(source_day)
        {
          activities: Trips::Activities.list(source_day).pluck(:id)
        }
      end

      def self.transferred_entities_for_day_info(source_day)
        {
          links: Trips::Links.list_day(source_day).pluck(:id),
          expenses: Trips::Expenses.list(source_day).pluck(:id),
          comment: source_day.comment
        }
      end

      # rubocop:disable MethodLength
      # rubocop:disable CyclomaticComplexity
      # rubocop:disable AbcSize
      def self.transfer(entities, target_day_id)
        entities.each do |field, value|
          case field
          when :transfers
            Travels::Transfer.where(id: value).update_all(day_id: target_day_id)
          when :hotel
            Travels::Hotel.where(id: value).update_all(day_id: target_day_id)
          when :places
            Travels::Place.where(id: value).update_all(day_id: target_day_id)
          when :activities
            Travels::Activity.where(id: value).update_all(day_id: target_day_id)
          when :links
            ExternalLink.where(id: value).update_all(linkable_id: target_day_id)
          when :expenses
            Travels::Expense.where(id: value).update_all(
              expendable_id: target_day_id
            )
          when :comment
            Travels::Day.where(id: target_day_id).update_all(comment: value)
          end
        end
      end
    end
  end
end
