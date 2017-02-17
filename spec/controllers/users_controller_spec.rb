# frozen_string_literal: true
require 'rails_helper'
RSpec.describe UsersController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#show' do
    context 'when user is logged in' do
      before { login_user(user) }

      context 'where there is user' do
        it 'renders show template' do
          get 'show', params: { id: subject.current_user.id }
          expect(response).to be_success
        end
      end

      context 'when there is no user' do
        it 'heads 404' do
          get 'show', params: { id: 'no user' }
          expect(response).to redirect_to '/errors/not_found'
        end
      end
    end

    context 'when no logged user' do
      let(:user) { FactoryGirl.create(:user) }
      context 'where there is user' do
        it 'renders show template' do
          get 'show', params: { id: user.id }
          expect(response).to be_success
        end
      end
    end
  end
end
