class Creators::Trip
  attr_accessor :old_trip, :params, :user

  def initialize(old_trip, params, user = nil)
    self.old_trip = old_trip
    self.params = params
    self.user = user
  end

  def new_trip
    new_trip = Travels::Trip.new
    new_trip.copy(old_trip) unless old_trip.blank?
    new_trip
  end

  def create_trip
    new_trip = Travels::Trip.new(params)
    new_trip.author_user_id = user.id
    new_trip.users = [user]
    new_trip.save
    copy_plan(old_trip, new_trip) unless old_trip.blank?
    new_trip
  end

  private

  def copy_plan from, to
    to.days.each_with_index do |day, index|
      original_day = (from.days || [])[index]
      next if original_day.blank?
      date_when = day.date_when
      day.copy(original_day, true)
      day.date_when = date_when
      day.save
    end

    from.caterings.each do |catering|
      to.caterings.create(catering.attributes.except('id', 'trip_id'))
    end
  end

end
