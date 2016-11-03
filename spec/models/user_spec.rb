# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  first_name             :string
#  last_name              :string
#  locale                 :string
#  image_uid              :string
#  created_at             :datetime
#  updated_at             :datetime
#  currency               :string
#  home_town_id           :integer
#

describe User do
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:first_name) }

  it_should_behave_like 'a model with unique field', :user, :email, false

  describe '#full_name' do
    let(:user) { FactoryGirl.create(:user) }

    it 'has full name' do
      expect(user.full_name).to eq('%s %s' % [user.first_name, user.last_name])
    end
  end

  describe '#home_town' do
    context 'valid simple user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'does not have home town' do
        expect(user.home_town).to be_blank
      end
    end

    context 'user with home town' do
      let(:user) { FactoryGirl.create(:user, :with_home_town) }

      it 'has home town from geo database' do
        town = user.home_town
        expect(town).not_to be_blank
        expect(town.id).to eq(user.home_town_id)
        expect(town.name).to eq(user.home_town_text)
      end
    end
  end

  describe '#trips' do
    context 'user with trips' do
      let(:user) { FactoryGirl.create(:user, :with_trips) }

      it 'can return list of trips in which participated' do
        expect(user.trips).not_to be_blank
        expect(user.trips.count).to eq(5)
      end
    end
  end

  describe '#manual_cities' do
    let(:user) { FactoryGirl.create(:user) }
    let(:city) { Geo::City.all.first }

    it 'can add and delete manual added cities' do
      user.manual_cities << city
      user.save
      expect(user.reload.manual_cities.count).to eq(1)

      user.manual_cities.delete(city)
      user.save
      expect(user.reload.manual_cities.count).to eq(0)
    end
  end

  describe '#find_by_term' do
    before do
      User.destroy_all
      FactoryGirl.create_list(:user, 5, first_name: 'Sven', last_name: 'Petersson')
      FactoryGirl.create_list(:user, 8, first_name: 'Max', last_name: 'Mustermann')
      FactoryGirl.create_list(:user, 15)
    end

    def check_order(users)
      users.each_with_index do |_, index|
        next if users[index + 1].blank?
        expect(users[index + 1].last_name).to be >= users[index].last_name
      end
    end

    it 'finds by last_name' do
      term = 'mus'
      users = User.find_by_term(term).to_a
      users.each { |user| expect(user.last_name =~ /#{term}/i).not_to be_blank }
      expect(users.count).to eq(8)
      check_order users
    end

    it 'finds by first_name' do
      term = 'sve'
      users = User.find_by_term(term).to_a
      users.each { |user| expect(user.first_name =~ /#{term}/i).not_to be_blank }
      expect(users.count).to eq(5)
      check_order users
    end
  end


end
