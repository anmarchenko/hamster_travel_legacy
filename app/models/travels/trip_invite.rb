# frozen_string_literal: true
# == Schema Information
#
# Table name: trip_invites
#
#  id               :integer          not null, primary key
#  inviting_user_id :integer
#  invited_user_id  :integer
#  trip_id          :integer
#

module Travels
  class TripInvite < ApplicationRecord
    belongs_to :inviting_user, class_name: 'User', inverse_of: :outgoing_invites
    belongs_to :invited_user, class_name: 'User', inverse_of: :incoming_invites
    belongs_to :trip, class_name: 'Travels::Trip', inverse_of: :pending_invites

    validates :invited_user_id, uniqueness: { scope: :trip_id }

    def as_json(*args)
      res = super
      res['inviting_user_name'] = inviting_user.full_name
      res['inviting_user_photo_url'] = inviting_user.image_url
      res['inviting_user_color'] = inviting_user.background_color
      res['inviting_user_initials'] = inviting_user.initials
      res['trip_name'] = trip.name
      res
    end
  end
end
