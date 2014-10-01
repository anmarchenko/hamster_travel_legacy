describe Travels::Day do
  describe '#init' do
    let(:day) {FactoryGirl.create(:trip).days.first}

    it 'has at least one place' do
      expect(day.places.count).to eq(1)
      day.places = []
      day.save validate: false
      expect(day.places.count).to eq(1)
    end

    it 'has hotel' do
      expect(day.hotel).not_to be_blank
      day.hotel = nil
      day.save validate: false
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
      before {day.set(comment: 'some comment')}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end

    context 'when day has a price' do
      before {day.set(add_price: rand(1000000))}
      it 'is true beacause add_price is no longer used' do
        expect(day).to be_is_empty
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
      before {day.hotel = FactoryGirl.build(:hotel, :with_data).attributes}
      it 'is false' do
        expect(day).not_to be_is_empty
      end
    end
  end

  describe '#as_json' do
    context 'when return json of a filled day' do
      let(:day) { FactoryGirl.create(:trip, :with_filled_days).days.first }
      let(:day_json) { day.as_json() }

      let(:day_empty) { FactoryGirl.create(:trip).days.first }
      let(:day_empty_json) { day_empty.as_json() }

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

      it 'has price' do
        expect(day_json['add_price']).to eq(day.add_price)
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
    end
  end

end