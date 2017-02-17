# frozen_string_literal: true
# == Schema Information
#
# Table name: trips
#
#  id                     :integer          not null, primary key
#  name                   :string
#  short_description      :text
#  start_date             :date
#  end_date               :date
#  archived               :boolean          default(FALSE)
#  comment                :text
#  budget_for             :integer          default(1)
#  private                :boolean          default(FALSE)
#  image_uid              :string
#  status_code            :string           default("0_draft")
#  author_user_id         :integer
#  updated_at             :datetime
#  created_at             :datetime
#  currency               :string
#  dates_unknown          :boolean          default(FALSE)
#  planned_days_count     :integer
#  countries_search_index :string
#

require 'rails_helper'
RSpec.describe Travels::Trip do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:author_user_id) }

  it_should_behave_like 'a model with date interval', :trip, :start_date,
                        :end_date

  it 'does not allow trips 30 days long' do
    trip = FactoryGirl.build(:trip,
                             start_date: Date.today,
                             end_date: Date.today + 30.days)
    expect(trip).not_to be_valid
  end

  it 'does not allow trips longer than 30 days' do
    trip = FactoryGirl.build(:trip, start_date: Date.today,
                                    end_date: Date.today + 35.days)
    expect(trip).not_to be_valid
  end

  it 'allows trip without dates if dates_unknown is set and trip is a draft' do
    trip = FactoryGirl.build(:trip, start_date: nil, end_date: nil,
                                    dates_unknown: true, planned_days_count: 1)
    expect(trip).to be_valid
  end

  it 'allows trip without dates if dates_unknown is set and trip is a plan' do
    trip = FactoryGirl.build(
      :trip,
      start_date: nil, end_date: nil,
      dates_unknown: true, planned_days_count: 1,
      status_code: Travels::Trip::StatusCodes::PLANNED
    )
    expect(trip).to be_valid
  end

  it 'does not allow trip without dates it has no planned_days_count' do
    trip = FactoryGirl.build(:trip, start_date: nil, end_date: nil,
                                    dates_unknown: true,
                                    planned_days_count: nil)
    expect(trip).not_to be_valid
  end
  it 'does not allow trip without dates with no days' do
    trip = FactoryGirl.build(:trip, start_date: nil, end_date: nil,
                                    dates_unknown: true, planned_days_count: 0)
    expect(trip).not_to be_valid
  end

  it 'does not allow trip without dates with 31 days' do
    trip = FactoryGirl.build(:trip, start_date: nil, end_date: nil,
                                    dates_unknown: true, planned_days_count: 31)
    expect(trip).not_to be_valid
  end

  describe '.where' do
    before(:each) do
      FactoryGirl.create_list(
        :trip,
        12,
        author_user_id: 'user_test_travels_trip'
      )
    end

    context 'when there are several trips' do
      it 'paginates per 10 items by default' do
        trips = Travels::Trip.all.page(1).to_a
        expect(trips.count).to eq(10)
      end

      context 'and when one deleted trip' do
        let!(:deleted_trip) do
          FactoryGirl.create(
            :trip, author_user_id: 'user_test_travels_trip', archived: true
          )
        end

        it 'returns only not deleted trips by default' do
          expect(
            Travels::Trip.unscoped
                          .where(id: deleted_trip.id, archived: true)
                          .first
          ).not_to be_blank
          trips = Travels::Trip.where(author_user_id: 'user_test_travels_trip')
                               .to_a
          expect(trips.count).to eq(12)
        end
      end
    end
  end

  describe '#include_user' do
    let(:trip) { FactoryGirl.create(:trip, :with_users) }
    let(:user) { FactoryGirl.create(:user) }

    it 'includes some user' do
      expect(trip.include_user(trip.author)).to be true
    end

    it 'does not include new user' do
      expect(trip.include_user(user)).to be false
    end
  end

  describe '#last_non_empty_day_index' do
    let(:trip_empty) { FactoryGirl.create(:trip) }
    let(:trip_full) { FactoryGirl.create(:trip, :with_filled_days) }

    it 'returns -1 if all days are empty' do
      expect(trip_empty.last_non_empty_day_index).to eq(-1)
    end

    it 'returns last day index if all days are non-empty' do
      expect(trip_full.last_non_empty_day_index).to eq(2)
    end

    it 'returns last non-empty day index' do
      trip_empty.days[0].comment = 'comment'
      trip_empty.days[0].save
      trip_empty.days[1].comment = 'comment'
      trip_empty.days[1].save
      expect(trip_empty.last_non_empty_day_index).to eq(1)
    end
  end

  describe '#budget_sum' do
    context 'when empty trip' do
      let(:trip) { FactoryGirl.create(:trip) }

      it 'returns zero' do
        expect(trip.budget_sum).to eq(0)
      end
    end

    context 'when filled trip' do
      let(:trip) do
        FactoryGirl.create(:trip, :with_filled_days, :with_caterings)
      end

      it 'returns right budget in right currency' do
        hotel_price = trip.days.inject(0) do |sum, day|
          sum + ((day.hotel.amount_cents || 0))
        end
        days_add_price = trip.days.inject(0) do |sum, day|
          sum + day.expenses.inject(0) do |i_s, ex|
            i_s + ((ex.amount_cents || 0))
          end
        end
        transfers_price = trip.days.inject(0) do |s, day|
          s + day.transfers.inject(0) do |i_s, tr|
            i_s + ((tr.amount_cents || 0))
          end
        end
        activities_price = trip.days.inject(0) do |s, day|
          s + day.activities.inject(0) do |i_s, ac|
            i_s + ((ac.amount_cents || 0))
          end
        end
        caterings_price = trip.caterings.inject(0) do |s, cat|
          s + ((cat.amount_cents || 0)) * cat.days_count * cat.persons_count
        end

        budget_eur = trip.budget_sum('EUR')
        should_be_eur = Money.new(
          [hotel_price, days_add_price,
           transfers_price, activities_price,
           caterings_price].reduce(&:+), 'RUB'
        ).exchange_to('EUR').to_f
        expect((budget_eur - should_be_eur).abs).to be < 1.0
      end
    end
  end

  describe '#name_for_file' do
    context 'for normal trip' do
      let(:trip) { FactoryGirl.create(:trip, name: 'simple') }

      it 'returns name' do
        expect(trip.name_for_file).to eq trip.name
      end
    end
    context 'for trip name with slash and spaces' do
      let(:trip) do
        FactoryGirl.create(:trip, name: 'trip with spaces/slash_underscore')
      end

      it 'returns safe name' do
        expect(trip.name_for_file).to eq 'trip_with_spaces_slash_underscore'
      end
    end
    context 'for russian trip name' do
      let(:trip) do
        FactoryGirl.create(:trip, name: 'DUbai in may')
      end

      it 'returns safe name' do
        expect(trip.name_for_file).to eq 'DUbai_in_may'
      end
    end
    context 'for long trip name' do
      let(:trip) do
        FactoryGirl.create(
          :trip,
          name: 'very very very very very very very very ' \
                'very very very very very very very very ' \
                'very very very very long name'
        )
      end

      it 'returns safe name' do
        expect(trip.name_for_file).to eq(
          'very_very_very_very_very_very_very_very_very_very_'
        )
      end
    end
  end

  describe '#as_json' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:trip_json) { trip.as_json }

    it 'has string id field' do
      expect(trip_json['id']).not_to be_blank
      expect(trip_json['id']).to be_a String
      expect(trip_json['id']).to eq(trip.id.to_s)
    end

    it 'has all attributes' do
      expect(trip_json['name']).to eq(trip.name)
      expect(trip_json['comment']).to eq(trip.comment)
      expect(trip_json['short_description']).to eq(trip.short_description)
      expect(trip_json['start_date']).to eq(trip.start_date)
      expect(trip_json['end_date']).to eq(trip.end_date)
      expect(trip_json['private']).to eq(trip.private)
      expect(trip_json['archived']).to eq(trip.archived)
      expect(trip_json['budget_for']).to eq(trip.budget_for)
    end
  end

  describe '#days_count' do
    context 'when new not saved trip' do
      let(:trip) { Travels::Trip.new }

      it 'returns nil' do
        expect(trip.days_count).to be_nil
      end
    end

    context 'when a week trip' do
      let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

      it 'returns 8 days' do
        expect(trip.days_count).to eq 3
      end
    end

    context 'when a minimal trip' do
      let(:trip) do
        FactoryGirl.create(
          :trip,
          start_date: Date.today,
          end_date: Date.today + 1
        )
      end

      it 'returns 2 days' do
        expect(trip.days_count).to eq 2
      end
    end

    context 'when trip without dates' do
      let(:trip) { FactoryGirl.create(:trip, :no_dates) }

      it 'returns planned_days_count' do
        expect(trip.days_count).to eq(trip.planned_days_count)
      end
    end
  end

  describe '#cities' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

    it 'returns list of all cities in trip' do
      expect(trip.cities.count).to eq(trip.days.count)
    end
  end

  describe '#visited_cities' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:visited_cities) { trip.visited_cities }

    it 'returns list of all unique cities in trip' do
      expect(visited_cities.count).to eq(1)
      expect(visited_cities.first).to eq(
        trip.places.where.not(city_id: nil).first.city
      )
    end
  end

  describe '#visited_countries_codes' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:visited_countries_codes) { trip.visited_countries_codes }

    it 'returns list of all unique countries in trip' do
      expect(visited_countries_codes.count).to eq(1)
      expect(visited_countries_codes.first).to eq(
        trip.visited_cities.first.country_code
      )
    end
  end
end
