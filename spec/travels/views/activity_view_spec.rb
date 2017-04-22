# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Views::ActivityView do
  describe '#show_json' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:days) { Trips::Days.list(trip) }
    let(:day) { days.first }
    let(:activity) { Trips::Activities.list(day).first }
    let(:activity_json) { subject.show_json activity }

    it 'has string id field' do
      expect(activity_json['id']).not_to be_blank
      expect(activity_json['id']).to be_a String
      expect(activity_json['id']).to eq(activity.id.to_s)
    end

    it 'has all attributes' do
      expect(activity_json['name']).to eq(activity.name)
      expect(activity_json['amount_cents']).to eq(activity.amount_cents)
      expect(activity_json['amount_currency']).to eq(activity.amount_currency)
      expect(activity_json['amount_currency_text']).to eq(
        activity.amount.currency.symbol
      )
      expect(activity_json['comment']).to eq(activity.comment)
      expect(activity_json['link_description']).to eq(activity.link_description)
      expect(activity_json['link_url']).to eq(activity.link_url)
      expect(activity_json['order_index']).to eq(activity.order_index)
    end
  end
end
