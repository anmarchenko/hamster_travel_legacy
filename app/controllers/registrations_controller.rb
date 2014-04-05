class RegistrationsController < Devise::RegistrationsController
  def new
    flash[:info] = t('devise.registrations.sorry')
    redirect_to root_path
  end

  def create
    flash[:info] = t('devise.registrations.sorry')
    redirect_to root_path
  end
end
