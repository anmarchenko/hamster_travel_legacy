describe User do

  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:first_name) }

  it_should_behave_like 'a model with unique field', :user, :email, false
  it_should_behave_like 'a model with typeahead field', :user, :home_town_text

  context 'valid simple user' do
    let(:user) {FactoryGirl.create(:user)}

    it 'has full name' do
      expect(user.full_name).to eq('%s %s' % [user.first_name, user.last_name])
    end

    it 'does not have home town' do
      expect(user.home_town).to be_blank
    end
  end

  context 'user with home town' do
    let(:user) {FactoryGirl.create(:user_with_home_town)}

    it 'has home town from geo database' do
      town = user.home_town
      expect(town).not_to be_blank
      expect(town.geonames_code).to eq(user.home_town_code)
      expect(town.name).to eq(user.home_town_text)
      expect(town.name_en).to eq(user.home_town_text)
    end
  end

end
