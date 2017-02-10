# frozen_string_literal: true
module ControllerMacros
  def login_user(user = nil)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    user ||= FactoryGirl.create(:user, :with_home_town)
    sign_in user
  end
end
