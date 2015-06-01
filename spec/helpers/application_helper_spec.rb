describe ApplicationHelper do
  describe '#exchange_money' do
    let(:money){helper.exchange_money('USD', 'RUB', 100)}

    it('performs exchange') {expect(money).not_to be_nil}
    it('exchanges to roubles') {expect(money.currency.iso_code).to eq('RUB')}
    it('knows the rate') {expect(money.to_f > 100.0).to eq(true)}
  end
end