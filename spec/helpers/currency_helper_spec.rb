# frozen_string_literal: true
require 'rails_helper'
RSpec.describe CurrencyHelper do
  describe '#currencies_select' do
    it 'returns currencies list for select' do
      list = [['Euro (EUR)', 'EUR', '€'], ['British Pound (GBP)', 'GBP', '£'], ['Russian Ruble (RUB)', 'RUB', "\u20BD"],
              ['United States Dollar (USD)', 'USD', '$'], ['Australian Dollar (AUD)', 'AUD', '$'],
              ['Bulgarian Lev (BGN)', 'BGN', 'лв.'], ['Brazilian Real (BRL)', 'BRL', 'R$'],
              ['Canadian Dollar (CAD)', 'CAD', '$'], ['Swiss Franc (CHF)', 'CHF', 'CHF'],
              ['Chinese Renminbi Yuan (CNY)', 'CNY', '¥'], ['Czech Koruna (CZK)', 'CZK', 'Kč'],
              ['Danish Krone (DKK)', 'DKK', 'kr.'], ['Hong Kong Dollar (HKD)', 'HKD', '$'],
              ['Croatian Kuna (HRK)', 'HRK', 'kn'], ['Hungarian Forint (HUF)', 'HUF', 'Ft'],
              ['Indonesian Rupiah (IDR)', 'IDR', 'Rp'], ['Israeli New Sheqel (ILS)', 'ILS', '₪'],
              ['Indian Rupee (INR)', 'INR', '₹'], ['Japanese Yen (JPY)', 'JPY', '¥'],
              ['South Korean Won (KRW)', 'KRW', '₩'], ['Mexican Peso (MXN)', 'MXN', '$'],
              ['Malaysian Ringgit (MYR)', 'MYR', 'RM'], ['Norwegian Krone (NOK)', 'NOK', 'kr'],
              ['New Zealand Dollar (NZD)', 'NZD', '$'], ['Philippine Peso (PHP)', 'PHP', '₱'],
              ['Polish Złoty (PLN)', 'PLN', 'zł'], ['Romanian Leu (RON)', 'RON', 'Lei'],
              ['Swedish Krona (SEK)', 'SEK', 'kr'], ['Singapore Dollar (SGD)', 'SGD', '$'],
              ['Thai Baht (THB)', 'THB', '฿'], ['Turkish Lira (TRY)', 'TRY', "\u20BA"],
              ['South African Rand (ZAR)', 'ZAR', 'R']]

      CurrencyHelper.currencies_select.each_with_index do |curr, index|
        expect(curr).to eq(list[index])
      end
    end
  end
end
