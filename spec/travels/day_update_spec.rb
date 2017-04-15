# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Trips::Days do
  def first_day_of(tr)
    tr.reload.days.first
  end

  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { first_day_of trip }

  describe '#process' do
    context 'when params have day attributes' do
      let(:params) do
        {
          comment: 'new_day_comment'
        }
      end

      it 'updates day data' do
        Trips::Days.save(day, params)
        updated_day = first_day_of(trip)
        expect(updated_day.id).to eq day.id
        expect(updated_day.comment).to eq 'new_day_comment'
      end

      it 'updates day data even if day attributes are empty' do
        Trips::Days.save(day, params)
        params[:comment] = ''
        Trips::Days.save(day, params)
        updated_day = first_day_of trip
        expect(updated_day.id).to eq day.id
        expect(updated_day.comment).to be_blank
      end
    end
  end
end
