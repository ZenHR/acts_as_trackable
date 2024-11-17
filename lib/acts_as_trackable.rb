require_relative 'acts_as_trackable/version'
require_relative 'acts_as_trackable/trackable'
require_relative 'acts_as_trackable/modifier'

module ActsAsTrackable
  class Error < StandardError; end

  extend ActiveSupport::Concern

  included do
    class_attribute :trackable_column
  end

  class_methods do
    def acts_as_trackable(column_name = :id)
      self.trackable_column = column_name
      validate_trackable_column
      include Trackable
    end

    def acts_as_modifier
      include Modifier
    end

    private

    def validate_trackable_column
      return if column_names.include?(trackable_column.to_s)

      raise ArgumentError, "Column '#{trackable_column}' does not exist in the table"
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActsAsTrackable
end
