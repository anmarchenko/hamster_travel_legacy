# frozen_string_literal: true

module Budgets
  BudgetInfo = Struct.new(
    :sum, :transfers_hotel, :activities_other, :catering, :people_count
  )

  # PUBLIC ACTIONS
  def self.on_budget_change(trip)
    %w[sum transfers_hotel activities_other catering].each do |method_name|
      CurrencyHelper::ECB_CURRENCIES.each do |currency|
        Rails.cache.delete(cache_key(method_name, trip, currency))
      end
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
    Money.new(
      Rails.cache.fetch(
        cache_key(method_name, trip, currency),
        expires_in: 1.day.to_i
      ) do
        value(method_name, trip, currency)
      end,
      currency
    ).to_f
  end

  def self.value(method_name, trip, currency)
    case method_name
    when 'sum'
      sum(trip, currency)
    when 'transfers_hotel'
      transfers_hotel(trip, currency)
    when 'activities_other'
      activities_other(trip, currency)
    when 'catering'
      catering(trip, currency)
    end
  end

  def self.sum(trip, currency)
    transfers_hotel(trip, currency) +
      activities_other(trip, currency) + catering(trip, currency)
  end

  def self.transfers_hotel(trip, currency)
    reduce_to_sum(trip.hotels, currency) +
      reduce_to_sum(trip.transfers, currency)
  end

  def self.activities_other(trip, currency)
    reduce_to_sum(trip.activities, currency) +
      reduce_to_sum(trip.expenses, currency)
  end

  def self.catering(trip, currency)
    result = Money.new(0, currency)
    trip.caterings.each do |catering|
      result += catering.amount.exchange_to(
        currency
      ) * (catering.days_count || 0) * (catering.persons_count || 0)
    end
    result.cents
  end

  def self.reduce_to_sum(entities, currency)
    result = Money.new(0, currency)
    entities.each do |entity|
      result += entity.amount.exchange_to(currency)
    end
    result.cents
  end

  def self.cache_key(method_name, trip, currency)
    "#{cache_prefix}_#{trip.id}_#{currency}_#{method_name}_#{cache_version}"
  end

  def self.cache_prefix
    'budget_' + Rails.env
  end

  def self.cache_version
    # 2016-12-29: Default currency changed to USD
    # 2017-02-10: Default currency changed to EUR
    # 2017-06-14: Store value with currency
    '2017_06_14'
  end
end
