shared_examples 'a model with typeahead field' do |model_factory, field|
  let(:code_field) {field.to_s.gsub('_text', '_id')}

  context "#{model_factory} with text and code" do
    let (:object) { FactoryGirl.build(model_factory, field => 'text_value', code_field => 'code_value')}

    it 'is valid' do
      expect(object).to be_valid
    end
  end

  context "#{model_factory} with text and no code" do
    let (:object) { FactoryGirl.build(model_factory, field => 'text_value')}

    it 'is not valid' do
      expect(object).not_to be_valid
    end
  end

end
