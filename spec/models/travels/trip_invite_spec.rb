# == Schema Information
#
# Table name: trip_invites
#
#  id               :integer          not null, primary key
#  inviting_user_id :integer
#  invited_user_id  :integer
#  trip_id          :integer
#

describe Travels::TripInvite do
  let(:trip) { FactoryGirl.create(:trip) }
  let(:inviting_user) { FactoryGirl.create(:user) }
  let(:invited_user) { FactoryGirl.create(:user) }

  it 'connects users and trip' do
    trip_invite = Travels::TripInvite.create(trip_id: trip.id, inviting_user_id: inviting_user.id,
                                             invited_user_id: invited_user.id)

    expect(trip_invite.persisted?).to eq(true)
    expect(trip.pending_invites.count).to eq(1)
    expect(inviting_user.outgoing_invites.count).to eq(1)
    expect(inviting_user.incoming_invites.count).to eq(0)
    expect(invited_user.incoming_invites.count).to eq(1)
    expect(invited_user.outgoing_invites.count).to eq(0)
  end
end
