# == Schema Information
#
# Table name: days
#
#  id        :integer          not null, primary key
#  date_when :date
#  comment   :text
#  trip_id   :integer
#  index     :integer
#

describe Travels::Day do
  describe '#init' do
    let(:day) {FactoryGirl.create(:trip).days.first}

    it 'has at least one place' do
      expect(day.places.count).to eq(1)
    end

    it 'has hotel' do
      expect(day.hotel).not_to be_blank
    end
  end

  describe '#is_empty?' do
    let(:day) {FactoryGirl.create(:trip).days.first}
    context 'default day' do
      it 'is true' do
        expect(day).to be_is_empty
      end
    end

    context 'when commented day' do
      before {day.comment = 'some comment'}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has empty expenses' do
      before {day.expenses.create(FactoryGirl.build(:expense).attributes)}

      it 'is true' do
        expect(day).to be_is_empty
      end
    end

    context 'when day has non empty expenses' do
      before {day.expenses.create(FactoryGirl.build(:expense, :with_data).attributes)}

      it 'is true' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has empty transfer' do
      before {day.transfers.create( FactoryGirl.build(:transfer).attributes )}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has non empty transfer' do
      before {day.transfers.create( FactoryGirl.build(:transfer, :with_destinations).attributes )}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has empty activity' do
      before {day.activities.create( FactoryGirl.build(:activity).attributes )}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has non empty transfer' do
      before {day.activities.create( FactoryGirl.build(:activity, :with_data).attributes )}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has empty places' do
      before {day.places.create( FactoryGirl.build(:place).attributes )}
      it 'is true' do
        expect(day).to be_is_empty
      end
    end

    context 'when day has non empty place' do
      before {day.places.create( FactoryGirl.build(:place, :with_data).attributes )}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has non empty hotel' do
      before {day.hotel = Travels::Hotel.new(FactoryGirl.build(:hotel, :with_data).attributes)}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end
  end

  describe '#short_hash' do
    let(:day) { FactoryGirl.create(:trip, :with_filled_days).days.first }

    it 'returns short representation of the day with 3 must see activities' do
      short_hash = day.short_hash
      expected_activities = day.activities.unscoped.where(day_id: day.id)
                                .order({rating: :desc, order_index: :asc}).first(3)
      actual_activities = short_hash[:activity_s].split('<br/>').first(3)
      3.times do |index|
        expect(actual_activities[index]).to eq("#{index + 1}. #{expected_activities[index].name}")
      end
    end
  end

  describe '#as_json' do
    context 'when return json of a filled day' do
      let(:day) { FactoryGirl.create(:trip, :with_filled_days).days.first }
      let(:day_json) { day.as_json(include: [:expenses, :activities, :links, :places, :transfers, :hotel]) }

      let(:day_empty) { FactoryGirl.create(:trip).days.first }
      let(:day_empty_json) { day_empty.as_json(include: [:expenses, :activities, :links, :places, :transfers, :hotel]) }

      let(:day_json_with_currency) {day.as_json(user_currency: 'EUR', include: [:expenses, :activities, :links, :places, :transfers, :hotel])}

      it 'has string id field' do
        expect(day_json['id']).not_to be_blank
        expect(day_json['id']).to be_a(String)
      end

      it 'has date in right format' do
        expect(day_json['date']).to eq( I18n.l(day.date_when, format: '%d.%m.%Y %A') )
      end

      it 'has 2 places' do
        expect(day_json['places'].count).to eq(2)
        expect(day_json['places'].last).to eq(day.places.last.as_json())
      end

      it 'has 2 transfers' do
        expect(day_json['transfers'].count).to eq(2)
        expect(day_json['transfers'].last).to eq(day.transfers.last.as_json())
      end

      it 'has 5 activities' do
        expect(day_json['activities'].count).to eq(5)
        expect(day_json['activities'].last).to eq(day.activities.last.as_json())
      end

      it 'has comment' do
        expect(day_json['comment']).to eq(day.comment)
      end

      it 'has hotel' do
        expect(day_json['hotel']).to eq(day.hotel.as_json())
      end

      it 'when empty has at least one expense' do
        expect(day_empty_json['expenses'].count).to eq(1)
      end

      it 'has expenses' do
        expect(day_json['expenses'].count).to eq(4)
        expect(day_json['expenses'].last).to eq(day.expenses.last.as_json())
      end

      it 'adds amounts in user currency' do
        expect(day_json_with_currency['expenses'].first['in_user_currency'][:amount_cents]).not_to be_blank
      end
    end
  end

end
