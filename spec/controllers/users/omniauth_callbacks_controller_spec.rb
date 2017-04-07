# frozen_string_literal: true

require 'rails_helper'

def omniauth(user_data)
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
    'uid' => '1234',
    'info' => user_data,
    'credentials' => {
      'token' => 'google_auth_token',
      'refresh_token' => 'google_refresh_token',
      'expires_at' => Time.now.to_i
    }
  )
end

RSpec.describe Users::OmniauthCallbacksController do
  let(:user_data) do
    {
      'first_name' => 'Googlefirstname',
      'last_name' => 'Googlelastname',
      'email' => 'omniauth@gmail.com',
      'image' => nil
    }
  end

  before do
    omniauth(user_data)
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google]
  end

  context 'user does not exist and needs to be created' do
    context 'user creation is successful' do
      it 'redirects with flash' do
        post :google_oauth2

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(
          I18n.t(
            'devise.omniauth_callbacks.success',
            kind: 'Google'
          )
        )

        user = User.find_by(email: 'omniauth@gmail.com')
        expect(user).not_to be_nil
        expect(user.first_name).to eq('Googlefirstname')
        expect(user.last_name).to eq('Googlelastname')
        expect(user.currency).to eq('USD')
        expect(user.locale).to eq('en')
        expect(user.google_oauth_uid).to eq('1234')
        expect(user.google_oauth_token).to eq('google_auth_token')
        expect(user.google_oauth_expires_at).not_to be_blank
        expect(user.google_oauth_refresh_token).to eq('google_refresh_token')
      end
    end

    context 'user creation failed' do
      context 'because image url is wrong' do
        let(:user_data) do
          {
            'first_name' => 'Googlefirstname',
            'last_name' => 'Googlelastname',
            'email' => 'omniauth@gmail.com',
            'image' => 'http://example.com/image.png'
          }
        end

        it 'redirects to sign in with error' do
          post :google_oauth2

          expect(response).to redirect_to '/users/sign_in'
          expect(flash[:alert]).to eq('Auth failed')
        end
      end

      context 'because of incomplete data from provider' do
        let(:user_data) do
          {
            'first_name' => nil,
            'last_name' => 'Googlelastname',
            'email' => 'omniauth@gmail.com',
            'image' => nil
          }
        end

        it 'redirects to sign in with error' do
          post :google_oauth2

          expect(response).to redirect_to '/users/sign_in'
          expect(flash[:alert]).to eq('Auth failed')
        end
      end
    end
  end

  context 'user exists' do
    context 'user never used google auth before' do
      let!(:user) do
        FactoryGirl.create(
          :user,
          email: 'omniauth@gmail.com',
          locale: 'ru',
          currency: 'EUR'
        )
      end

      it 'signs user in and updates only google_oath data' do
        post :google_oauth2

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(
          I18n.t(
            'devise.omniauth_callbacks.success',
            kind: 'Google'
          )
        )

        updated_user = user.reload
        expect(updated_user.first_name).not_to eq('Googlefirstname')
        expect(updated_user.last_name).not_to eq('Googlelastname')
        expect(updated_user.currency).to eq('EUR')
        expect(updated_user.locale).to eq('ru')
        expect(updated_user.google_oauth_uid).to eq('1234')
        expect(updated_user.google_oauth_token).to eq('google_auth_token')
        expect(updated_user.google_oauth_expires_at).not_to be_blank
        expect(updated_user.google_oauth_refresh_token).to eq(
          'google_refresh_token'
        )
      end
    end

    context 'user used google auth before' do
      let!(:user) do
        FactoryGirl.create(
          :user,
          email: 'omniauth@gmail.com',
          google_oauth_uid: '12324325',
          google_oauth_refresh_token: 'old_token'
        )
      end

      it 'signs user in and does not update any data' do
        post :google_oauth2

        expect(response).to have_http_status(:redirect)
        expect(flash[:notice]).to eq(
          I18n.t(
            'devise.omniauth_callbacks.success',
            kind: 'Google'
          )
        )

        updated_user = user.reload
        expect(updated_user.first_name).not_to eq('Googlefirstname')
        expect(updated_user.last_name).not_to eq('Googlelastname')
        expect(updated_user.google_oauth_uid).to eq('12324325')
        expect(updated_user.google_oauth_token).to be_blank
        expect(updated_user.google_oauth_expires_at).to be_blank
        expect(updated_user.google_oauth_refresh_token).to eq(
          'old_token'
        )
      end
    end
  end
end
