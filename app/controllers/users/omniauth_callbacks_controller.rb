# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth = request.env['omniauth.auth']
      Omniauth::Google.call(auth) do |result, user|
        case result
        when :ok
          success_auth(user)
        when :failure
          failure_auth
        end
      end
    end

    private

    def success_auth(user)
      flash[:notice] = I18n.t(
        'devise.omniauth_callbacks.success',
        kind: 'Google'
      )
      sign_in_and_redirect user, event: :authentication
    end

    def failure_auth
      flash[:alert] = 'Auth failed'
      redirect_to '/users/sign_in'
    end
  end
end
