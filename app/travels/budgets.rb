# frozen_string_literal: true

module Budgets
  BudgetInfo = Struct.new(
    :sum, :transfers_hotel, :activities_other, :catering, :people_count
  )

  # PUBLIC ACTIONS
  def self.on_budget_change(trip)
    %w[sum transfers_hotel activities_other catering].each do |method_name|
      Rails.cache.delete(cache_key(method_name, trip))
    end
  end

  def self.calculate_info(trip, currency = CurrencyHelper::DEFAULT_CURRENCY)
    currency ||= CurrencyHelper::DEFAULT_CURRENCY
    BudgetInfo.new(
      budget_value('sum', trip, currency),
      budget_value('transfers_hotel', trip, currency),
      budget_value('activities_other', trip, currency),
      budget_value('catering', trip, currency),
      trip.budget_for
    )
  end

  # INTERNAL ACTIONS
  def self.budget_value(method_name, trip, currency)
    exchange_from_default(
      Rails.cache.fetch(cache_key(method_name, trip), expires_in: 1.day.to_i) do
        value_in_default_currency(method_name, trip)
      end,
      currency
    )
  end

  def self.exchange_from_default(result_in_default_currency, required_currency)
    Money.new(
      result_in_default_currency, CurrencyHelper::DEFAULT_CURRENCY
    ).exchange_to(required_currency).to_f
  end

  def self.value_in_default_currency(method_name, trip)
    case method_name
    when 'sum'
      sum_in_default_currency(trip)
    when 'transfers_hotel'
      transfers_hotel_in_default_currency(trip)
    when 'activities_other'
      activities_other_in_default_currency(trip)
    when 'catering'
      catering_in_default_currency(trip)
    end
  end

  def self.sum_in_default_currency(trip)
    transfers_hotel_in_default_currency(trip) +
      activities_other_in_default_currency(trip) +
      catering_in_default_currency(trip)
  end

  def self.transfers_hotel_in_default_currency(trip)
    reduce_to_sum_in_default_currency(trip.hotels) +
      reduce_to_sum_in_default_currency(trip.transfers)
  end

  def self.activities_other_in_default_currency(trip)
    reduce_to_sum_in_default_currency(trip.activities) +
      reduce_to_sum_in_default_currency(trip.expenses)
  end

  def self.catering_in_default_currency(trip)
    result = Money.new(0, CurrencyHelper::DEFAULT_CURRENCY)
    trip.caterings.each do |catering|
      result += catering.amount.exchange_to(
        CurrencyHelper::DEFAULT_CURRENCY
      ) * (catering.days_count || 0) * (catering.persons_count || 0)
    end
    result.cents
  end

  def self.reduce_to_sum_in_default_currency(entities)
    result = Money.new(0, CurrencyHelper::DEFAULT_CURRENCY)
    entities.each do |entity|
      result += entity.amount.exchange_to(
        CurrencyHelper::DEFAULT_CURRENCY
      )
    end
    result.cents
  end

  def self.cache_key(method_name, trip)
    cache_prefix + trip.id.to_s + '_' + method_name + cache_version
  end

  def self.cache_prefix
    'budget_' + Rails.env + '_'
  end

  def self.cache_version
    # 2016-12-29: Default currency changed to USD
    # 2017-02-10: Default currency changed to EUR
    '_2017_02_10'
  end
end
