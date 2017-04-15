# frozen_string_literal: true

module Omniauth
  module Google
    def self.call(auth)
      user = user_from_auth(auth)
      user = create_user_from_auth(auth) if user.blank?

      if user.present? && user.persisted?
        update_user(user, auth)
        yield :ok, user
      else
        Rails.logger.error('[GOOGLEAUTH] User creation failed')
        Rails.logger.error("[GOOGLEAUTH] E #{user.errors}") if user.present?
        yield :failure
      end
    end

    def self.update_user(user, auth)
      return if user.google_oauth_uid.present?
      user.update_attributes(
        google_oauth_uid: auth['uid'],
        google_oauth_token: auth['credentials']['token'],
        google_oauth_expires_at: Time.at(auth['credentials']['expires_at']),
        google_oauth_refresh_token: auth['credentials']['refresh_token']
      )
    end

    def self.user_from_auth(auth)
      User.where(email: auth.info['email']).first
    end

    def self.create_user_from_auth(auth)
      User.create(user_params(auth))
    rescue Dragonfly::Job::FetchUrl::ErrorResponse => e # image not found
      Rails.logger.error(
        '[GOOGLEAUTH] Unable to fetch avatar image from Google! ' \
        "Message is #{e.message}. Url is #{auth.info['image']}"
      )
      nil
    end

    def self.user_params(auth)
      password = SecureRandom.uuid.delete('-')
      {
        first_name: auth.info['first_name'], last_name: auth.info['last_name'],
        email: auth.info['email'], image_url: auth.info['image'],
        password: password, password_confirmation: password,
        currency: 'USD', locale: 'en'
      }
    end
  end
end
