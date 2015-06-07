describe CurrencyHelper do
  describe '#currencies_select' do
    it 'returns currencies list for select' do
      list = [["Euro (EUR)", "EUR"], ["British Pound (GBP)", "GBP"], ["Russian Ruble (RUB)", "RUB"], ["United States Dollar (USD)", "USD"],
              ["Australian Dollar (AUD)", "AUD"], ["Bulgarian Lev (BGN)", "BGN"], ["Brazilian Real (BRL)", "BRL"],
              ["Canadian Dollar (CAD)", "CAD"], ["Swiss Franc (CHF)", "CHF"], ["Chinese Renminbi Yuan (CNY)", "CNY"],
              ["Czech Koruna (CZK)", "CZK"], ["Danish Krone (DKK)", "DKK"], ["Hong Kong Dollar (HKD)", "HKD"],
              ["Croatian Kuna (HRK)", "HRK"], ["Hungarian Forint (HUF)", "HUF"], ["Indonesian Rupiah (IDR)", "IDR"],
              ["Israeli New Sheqel (ILS)", "ILS"], ["Indian Rupee (INR)", "INR"], ["Japanese Yen (JPY)", "JPY"],
              ["South Korean Won (KRW)", "KRW"], ["Mexican Peso (MXN)", "MXN"], ["Malaysian Ringgit (MYR)", "MYR"],
              ["Norwegian Krone (NOK)", "NOK"], ["New Zealand Dollar (NZD)", "NZD"], ["Philippine Peso (PHP)", "PHP"],
              ["Polish Złoty (PLN)", "PLN"], ["Romanian Leu (RON)", "RON"], ["Swedish Krona (SEK)", "SEK"],
              ["Singapore Dollar (SGD)", "SGD"], ["Thai Baht (THB)", "THB"], ["Turkish Lira (TRY)", "TRY"],
              ["South African Rand (ZAR)", "ZAR"]]

      expect(CurrencyHelper.currencies_select).to eq(list)
    end
  end
end