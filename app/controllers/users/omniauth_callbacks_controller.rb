# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth = request.env['omniauth.auth']
      @user = user_from_auth(auth)

      if @user.present?
        update_user(auth)
        success_auth
      else
        @user = create_user_from_auth(auth)
        if @user.persisted?
          update_user(auth)
          success_auth
        else
          Rails.logger.error(@user.errors)
          failure_auth
        end
      end
    end

    private

    def update_user(auth)
      @user.update_attributes(
        google_oauth_uid: auth['uid'],
        google_oauth_token: auth['credentials']['token'],
        google_oauth_expires_at: Time.at(auth['credentials']['expires_at']),
        google_oauth_refresh_token: auth['credentials']['refresh_token']
      )
    end

    def success_auth
      flash[:notice] = I18n.t(
        'devise.omniauth_callbacks.success',
        kind: 'Google'
      )
      sign_in_and_redirect @user, event: :authentication
    end

    def failure_auth
      flash[:alert] = 'Something went wrong!'
      redirect_to '/users/sign_in'
    end

    def user_from_auth(auth)
      User.where(email: auth.info['email']).first
    end

    def create_user_from_auth(auth)
      password = SecureRandom.uuid.delete('-')
      User.create(
        first_name: auth.info['first_name'],
        last_name: auth.info['last_name'],
        email: auth.info['email'],
        image_url: auth.info['image'],
        password: password,
        password_confirmation: password,
        currency: 'USD',
        locale: 'en'
      )
    end
  end
end
