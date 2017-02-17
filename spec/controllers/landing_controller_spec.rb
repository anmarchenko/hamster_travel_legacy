# frozen_string_literal: true
require 'rails_helper'
RSpec.describe LandingController do
  describe '#index' do
    it 'should render page' do
      get 'index'
      expect(response).to be_success
    end
  end
end
