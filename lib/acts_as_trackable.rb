require_relative 'acts_as_trackable/version'
require_relative 'acts_as_trackable/trackable'
require_relative 'acts_as_trackable/modifier'

module ActsAsTrackable
  class Error < StandardError; end

  extend ActiveSupport::Concern

  included do
    class_attribute :trackable_column, :fallback_to_base_class
  end

  class_methods do
    def acts_as_trackable(column_name = :id, fallback_to_base_class: false)
      self.trackable_column       = column_name
      self.fallback_to_base_class = fallback_to_base_class
      validate_attributes
      include Trackable
    end

    def acts_as_modifier
      include Modifier
    end

    private

    def validate_attributes
      validate_trackable_column
      validate_fallback_to_base_class
    end

    def validate_trackable_column
      return if column_names.include?(trackable_column.to_s)

      raise ArgumentError, "Column '#{trackable_column}' does not exist in the table"
    end

    def validate_fallback_to_base_class
      return if fallback_to_base_class.nil? || [true, false].include?(fallback_to_base_class)

      raise ArgumentError, 'fallback_to_base_class must be a boolean'
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActsAsTrackable
end
