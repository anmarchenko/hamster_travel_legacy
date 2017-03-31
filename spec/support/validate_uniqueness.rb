# frozen_string_literal: true

RSpec.shared_examples(
  'a model with unique field'
) do |model_factory, field, case_sensitive|
  let(:object) { FactoryGirl.create(model_factory) }

  it "validates that #{field} is unique for #{model_factory}" do
    object_repeat = FactoryGirl.build(
      model_factory, field => object.send(field)
    )
    expect(object_repeat).not_to be_valid
  end

  it "lets to register new #{model_factory} with different #{field} value" do
    object_repeat = FactoryGirl.build(model_factory)
    expect(object_repeat).to be_valid
  end

  context "with repeat object having capitalized #{field}" do
    let(:object_repeat) do
      FactoryGirl.build(model_factory, field => object.send(field).upcase)
    end
    it "validates that #{field} is unique for #{model_factory}" \
       " case #{!case_sensitive ? 'in' : ''}sensitive" do
      if case_sensitive
        expect(object_repeat).to be_valid
      else
        expect(object_repeat).not_to be_valid
      end
    end
  end
end
