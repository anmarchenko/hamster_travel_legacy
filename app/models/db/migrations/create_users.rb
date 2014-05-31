module Db
  module Migrations
    class CreateUsers

      USERS =[
        {
          email: 'altmer@mail.test',
          password: Rails.application.secrets.andrey_password,
          password_confirmation: Rails.application.secrets.andrey_password,
          first_name: 'Andrey',
          last_name: 'Marchenko',
          locale: 'ru'
        },
        {
          email: 'hamster@mail.test',
          password: Rails.application.secrets.yuliya_password,
          password_confirmation: Rails.application.secrets.yuliya_password,
          first_name: 'Yuliya',
          last_name: 'Marchenko',
          locale: 'ru'
        }
      ]

      def self.perform
        User.delete_all
        USERS.each do |hash|
          user = User.create(hash)
          puts "ERROR: #{user.email} was not created: #{user.errors.full_messages}" unless user.errors.blank?
        end
      end

    end
  end
end