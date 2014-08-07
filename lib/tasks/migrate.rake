# -*- encoding: utf-8 -*-
namespace :db do
  desc 'migrations'
  task :migrate, [] => :environment do

    # { class_name: times }
    # class_name - name of class, which has method perform
    # times - once or forever or never. never - default

    Db::Migration.registrate!({
      'Db::Migrations::CreateUsers' => 'once',
      'Db::Migrations::DefaultUsersHometown' => 'once',
      'Db::Migrations::GeoFixes' => 'once'
    })

    Db::Migration.run_all!

  end
end
