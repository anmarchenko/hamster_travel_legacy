# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trips do
  let(:user) { FactoryGirl.create(:user) }

  describe '.new_trip' do
    subject { Trips.new_trip(user, original_trip_id) }

    context 'no original trip to copy from' do
      let(:original_trip_id) { nil }

      it 'returns new trip' do
        expect(subject).to be_a_new(Travels::Trip)
      end
    end

    context 'copy from original trip' do
      let(:original_trip) { FactoryGirl.create(:trip, currency: 'RON') }
      let(:original_trip_id) { original_trip.id }

      it 'returns new trip copied from original' do
        expect(subject).to be_a_new(Travels::Trip)

        expect(subject.currency).to eq 'RON'
        expect(subject.name).to(
          eq("#{original_trip.name} (#{I18n.t('common.copy')})")
        )
        expect(subject.start_date).to eq original_trip.start_date
        expect(subject.end_date).to eq original_trip.end_date
        expect(subject.short_description).to be_nil

        expect(subject.comment).to be_nil
        expect(subject.archived).to be false
        expect(subject.private).to be false
        expect(subject.image_uid).to be_nil
        expect(subject.status_code).to eq Travels::Trip::StatusCodes::DRAFT
      end
    end
  end

  describe '.create_trip' do
    let(:params) do
      FactoryGirl.build(:trip)
                 .attributes
                 .with_indifferent_access
                 .merge(currency: 'INR')
                 .slice(
                   :name, :short_description, :start_date,
                   :end_date, :image, :status_code,
                   :private, :currency, :planned_days_count, :dates_unknown
                 )
    end

    subject { Trips.create_trip(params, user, original_trip_id) }

    context 'no original trip' do
      let(:original_trip_id) { nil }
      it 'creates new trip from params' do
        expect(subject).to be_persisted
        expect(subject.author_user).to eq user
        expect(subject.users).to eq [user]
        expect(subject.name).to eq params['name']
        expect(subject.short_description).to eq(
          params['short_description']
        )
        expect(subject.start_date).to eq params['start_date']
        expect(subject.end_date).to eq params['end_date']
        expect(subject.currency).to eq('INR')
        expect(subject.days.first.hotel.amount_currency).to eq('INR')
      end
    end

    context 'original trip' do
      let(:original_trip) do
        FactoryGirl.create(:trip, :with_filled_days, users: [user])
      end
      let(:original_trip_id) { original_trip.id }

      it 'creates new trip from params and data from original trip' do
        expect(subject.comment).to be_nil
        expect(subject.days.count).to eq(original_trip.days.count)

        expect(subject.days.first.comment).to eq(
          original_trip.days.first.comment
        )
        expect(subject.days.first.date_when).to eq(
          params['start_date']
        )
        expect(subject.days.first.transfers.count).to eq(
          original_trip.days.first.transfers.count
        )
        expect(subject.days.first.transfers.first.amount).to eq(
          original_trip.days.first.transfers.first.amount
        )

        expect(subject.days.first.places.count).to eq(
          original_trip.days.first.places.count
        )
        expect(subject.days.first.hotel.name).to eq(
          original_trip.days.first.hotel.name
        )
        expect(subject.days.first.hotel.links.count).to eq(
          original_trip.days.first.hotel.links.count
        )
        expect(subject.days.first.hotel.links.first.url).to eq(
          original_trip.days.first.hotel.links.first.url
        )

        expect(subject.days.last.comment).to eq(
          original_trip.days.last.comment
        )
        expect(subject.days.last.date_when).to eq(
          params['end_date']
        )

        expect(subject.caterings.count).to eq(original_trip.caterings.count)
        new_names_caterings = subject.caterings.map(&:name).sort
        old_names_caterings = original_trip.caterings.map(&:name).sort
        expect(new_names_caterings).to eq(old_names_caterings)
      end
    end
  end
end
