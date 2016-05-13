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
#  mongo_id         :string
#  day_id           :integer
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string           default("RUB"), not null
#  rating           :integer          default(2)
#  address          :string
#  working_hours    :string
#

describe Travels::Activity do
  describe '.where' do
    let(:day) {FactoryGirl.create(:trip, :with_filled_days).days.first}

    it 'returns activities by order_index' do
      activs = day.activities.to_a
      activs.each_index do |i|
        next if activs[i+1].blank?
        expect(activs[i].order_index).to be < (activs[i+1].order_index)
      end
    end

    context 'when order_index was changed' do
      let!(:activity_first) {day.activities.first}
      let!(:activity_second) {day.activities[1]}

      before {activity_first.update_attributes(order_index: 1)}
      before {activity_second.update_attributes(order_index: 0)}

      it 'returns activities in new order' do
        activs = day.reload.activities.to_a
        expect(activs[0].order_index).to eq(0)
        expect(activs[0].id).to eq(activity_second.id)
        expect(activs[1].order_index).to eq(1)
        expect(activs[1].id).to eq(activity_first.id)
      end
    end
  end

  describe '#link_description' do
    let(:activity) {FactoryGirl.create(:trip, :with_filled_days).days.first.activities.first}

    it 'returns host' do
      expect(activity.link_description).to eq 'Cool.site'
    end
  end

  describe '#as_json' do

    let(:activity) {FactoryGirl.create(:trip, :with_filled_days).days.first.activities.first}
    let(:activity_json) {activity.as_json}

    it 'has string id field' do
      expect(activity_json['id']).not_to be_blank
      expect(activity_json['id']).to be_a String
      expect(activity_json['id']).to eq(activity.id.to_s)
    end

    it 'has all attributes' do
      expect(activity_json['name']).to eq(activity.name)
      expect(activity_json['amount_cents']).to eq(activity.amount_cents)
      expect(activity_json['amount_currency']).to eq(activity.amount_currency)
      expect(activity_json['amount_currency_text']).to eq(activity.amount.currency.symbol)
      expect(activity_json['comment']).to eq(activity.comment)
      expect(activity_json['link_description']).to eq(activity.link_description)
      expect(activity_json['link_url']).to eq(activity.link_url)
      expect(activity_json['order_index']).to eq(activity.order_index)
    end

  end

end
