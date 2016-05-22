describe Updaters::Transfers do
  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { trip.days.first }

  let(:params) {
    [
        {
            city_from_id: Geo::City.all.to_a[0].id,
            city_to_id: Geo::City.all.to_a[1].id,
            links: [
                {id: nil, url: 'https://google.com', description: 'desc1'},
                {id: nil, url: 'https://rome2rio.com', description: 'desc2'}
            ]
        }.with_indifferent_access,
        {
            city_from_id: Geo::City.all.to_a[1].id,
            city_to_id: Geo::City.all.to_a[1].id,
        }.with_indifferent_access,
        {
            city_from_id: Geo::City.all.to_a[2].id,
            city_to_id: Geo::City.all.to_a[2].id,
        }.with_indifferent_access,
        {
            city_from_id: Geo::City.all.to_a[3].id,
            city_to_id: Geo::City.all.to_a[3].id,
        }.with_indifferent_access
    ]

  }

  it 'creates new transfers' do
    ::Updaters::Transfers.new(day, params).process

    updated_day = trip.days.first.reload
    expect(updated_day.transfers.count).to eq 4

    expect(updated_day.transfers.first.city_from_id).to eq Geo::City.all.to_a[0].id
    expect(updated_day.transfers.first.city_to_id).to eq Geo::City.all.to_a[1].id
    expect(updated_day.transfers.first.links.count).to eq(2)
  end

  it 'reorders transfers' do
    ::Updaters::Transfers.new(day, params).process

    original_transfers = day.transfers.to_a

    old_transfers = params
    old_transfers.each_with_index do |tr, index|
      tr[:id] = day.transfers[index].id.to_s
    end
    permutation = {0 => 3, 1 => 1, 2 => 0, 3 => 2}
    new_params = [old_transfers[3], old_transfers[1], old_transfers[0], old_transfers[2]]

    ::Updaters::Transfers.new(day, new_params).process

    updated_day = trip.days.first.reload
    expect(updated_day.transfers.count).to eq 4
    updated_day.transfers.each_with_index do |tr, index|
      expect(tr.city_from_id).to eq Geo::City.all.to_a[permutation[index]].id
      expect(tr.order_index).to eq index
      expect(tr.id).to eq original_transfers[permutation[index]].id
    end

  end

end