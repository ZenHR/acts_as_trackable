require 'rails/generators/active_record'
require 'rails/generators/named_base'

module ActsAsTrackable
  module Generators
    class ObjectActivityGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_migration
        migration_file_name = "create_object_activity.rb"
        timestamp           = Time.now.utc.strftime("%Y%m%d%H%M%S")
        destination         = File.join('db', 'migrate', "#{timestamp}_#{migration_file_name}")

        template migration_file_name, destination
      end

      def create_model_file
        template 'object_activity.rb', File.join('app/models', class_path, "#{file_name}.rb")
      end
    end
  end
end
