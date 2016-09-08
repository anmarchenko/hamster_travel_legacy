class RegistrationsController < Devise::RegistrationsController
  def new
    flash[:info] = t('devise.registrations.sorry')
    redirect_to root_path
  end

  def create
    flash[:info] = t('devise.registrations.sorry')
    redirect_to root_path
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end
end
