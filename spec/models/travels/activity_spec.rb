# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  order_index      :integer
#  name             :string
#  comment          :text
#  link_description :string
#  link_url         :text
#  day_id           :integer
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string           default("RUB"), not null
#  rating           :integer          default(2)
#  address          :string
#  working_hours    :string
#

require 'rails_helper'

RSpec.describe Travels::Activity do
  describe '.ordered' do
    let(:day) do
      FactoryGirl.create(:trip, :with_filled_days).days.ordered.first
    end

    it 'returns activities by order_index' do
      activs = day.activities.ordered.to_a
      activs.each_index do |i|
        next if activs[i + 1].blank?
        expect(activs[i].order_index).to be < activs[i + 1].order_index
      end
    end

    context 'when order_index was changed' do
      let!(:activity_first) { day.activities.ordered.first }
      let!(:activity_second) { day.activities.ordered[1] }

      before { activity_first.update_attributes(order_index: 1) }
      before { activity_second.update_attributes(order_index: 0) }

      it 'returns activities in new order' do
        activs = day.reload.activities.ordered.to_a
        expect(activs[0].order_index).to eq(0)
        expect(activs[0].id).to eq(activity_second.id)
        expect(activs[1].order_index).to eq(1)
        expect(activs[1].id).to eq(activity_first.id)
      end
    end
  end

  describe '#link_description' do
    let(:activity) do
      FactoryGirl.create(:trip, :with_filled_days).days.ordered.first
                 .activities.ordered.first
    end

    it 'returns host' do
      expect(activity.link_description).to eq 'Cool.site'
    end
  end
end
