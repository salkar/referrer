require 'rails/generators/active_record'

class Referrer::TrackingGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_referrer_migration
    migration_template 'migration.rb', "db/migrate/add_referrer_tracking_to_#{table_name}.rb", migration_version: migration_version
  end

  protected

  def migration_version
    if Rails::VERSION::MAJOR >= 5
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end
  end
end
