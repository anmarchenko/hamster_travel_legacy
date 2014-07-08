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
end