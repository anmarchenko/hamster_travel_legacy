class Calculators::Budget
  attr_accessor :trip, :currency

  def initialize(trip, currency = nil)
    self.trip = trip
    self.currency = currency || CurrencyHelper::DEFAULT_CURRENCY
  end

  def sum
    exchange(Rails.cache.fetch(cache_key('sum'), expires_in: 1.day.to_i) do
      transfers_hotel_cents + activities_other_cents + catering_cents
    end)
  end

  def transfers_hotel
    exchange(transfers_hotel_cents)
  end

  def activities_other
    exchange(activities_other_cents)
  end

  def catering
    exchange(catering_cents)
  end

  def invalidate_cache!
    ['sum', 'transfers_hotel', 'activities_other', 'catering'].each do |method_name|
      Rails.cache.delete(cache_key(method_name))
    end
  end

  private

  def transfers_hotel_cents
    Rails.cache.fetch(cache_key('transfers_hotel'), expires_in: 1.day.to_i) do
      result = Money.new(0, CurrencyHelper::DEFAULT_CURRENCY)
      (trip.days.includes(:hotel, :transfers, :activities, :expenses) || []).each do |day|
        result += day.hotel.amount.exchange_to(CurrencyHelper::DEFAULT_CURRENCY)
        (day.transfers || []).each { |transfer| result += transfer.amount.exchange_to(CurrencyHelper::DEFAULT_CURRENCY) }
      end
      result.cents
    end
  end

  def activities_other_cents
    Rails.cache.fetch(cache_key('activities_other'), expires_in: 1.day.to_i) do
      result = Money.new(0, CurrencyHelper::DEFAULT_CURRENCY)
      (trip.days.includes(:hotel, :transfers, :activities, :expenses) || []).each do |day|
        (day.activities || []).each { |activity| result += activity.amount.exchange_to(CurrencyHelper::DEFAULT_CURRENCY) }
        (day.expenses || []).each { |expense| result += expense.amount.exchange_to(CurrencyHelper::DEFAULT_CURRENCY) }
      end
      result.cents
    end
  end

  def catering_cents
    Rails.cache.fetch(cache_key('catering'), expires_in: 1.day.to_i) do
      result = Money.new(0, CurrencyHelper::DEFAULT_CURRENCY)
      (trip.caterings || []).each do |catering|
        result += catering.amount.exchange_to(CurrencyHelper::DEFAULT_CURRENCY) * catering.days_count * catering.persons_count
      end
      result.cents
    end
  end

  def exchange(integer_result)
    Money.new(integer_result, CurrencyHelper::DEFAULT_CURRENCY).exchange_to(currency).to_f
  end

  def cache_key(method_name)
    cache_prefix + trip.id.to_s + '_' + method_name + cache_version
  end

  def cache_prefix
    'budget_' + Rails.env + '_'
  end

  def cache_version
    # 2026-12-29: Default currency changed to USD
    '_2016_12_29'
  end
end
