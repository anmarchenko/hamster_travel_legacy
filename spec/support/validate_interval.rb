shared_examples 'a model with date interval' do |model_factory, start_date_field, end_date_field|

  context "#{model_factory} with valid interval" do
    let (:object) { FactoryGirl.build(model_factory, start_date_field => 3.days.ago, end_date_field => Date.today)}

    it 'is valid' do
      expect(object).to be_valid
    end
  end

  context "#{model_factory} with border invalid interval" do
    let (:object) { FactoryGirl.build(model_factory, start_date_field => Date.today, end_date_field => Date.today)}

    it 'is valid' do
      expect(object).to be_valid
    end
  end

  context "#{model_factory} with invalid interval" do
    let (:object) { FactoryGirl.build(model_factory, start_date_field => Date.today, end_date_field => 1.day.ago)}

    it 'is not valid' do
      expect(object).not_to be_valid
    end
  end

end
