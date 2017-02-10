# frozen_string_literal: true
class Creators::Trip
  attr_accessor :old_trip, :params, :user

  def initialize(old_trip, params, user = nil)
    self.old_trip = old_trip
    self.params = params
    self.user = user
  end

  def new_trip
    if old_trip.blank?
      new_trip = Travels::Trip.new
    else
      new_trip = old_trip.deep_clone except: [:short_description, :private, :comment, :image_uid]
      new_trip.name += " (#{I18n.t('common.copy')})" unless new_trip.name.blank?
    end
    new_trip
  end

  def create_trip
    if old_trip.blank?
      new_trip = Travels::Trip.new(params)
    else
      new_trip = old_trip.deep_clone include: [{ days: [
        :places, :activities, { transfers: :links }, :hotel, :expenses, :links
      ] }, :caterings], except: [:short_description, :private, :comment, :image_uid]
      new_trip.assign_attributes(params)
    end
    new_trip.author_user_id = user.id
    new_trip.users = [user]
    new_trip.save
    new_trip
  end
end
