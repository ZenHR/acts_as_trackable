require 'active_support/concern'

module Trackable
  extend ActiveSupport::Concern

  included do
    attr_accessor :modifier

    has_one :object_activity, as: :object, dependent: :destroy

    define_method :object_activity do
      # Return cached value if already set
      return @object_activity if defined?(@object_activity)

      # If the association is preloaded use it
      if association(:object_activity).loaded?
        loaded = association(:object_activity).target

        if loaded&.object_id == id &&
          [self.class.name, self.class.base_class.name].include?(loaded.object_type)
          @object_activity = loaded
        end
      end

      # Fallback to DB query if not preloaded or not matched
      @object_activity ||= ObjectActivity.find_by(
        object_id: id,
        object_type: [self.class.name, self.class.base_class.name]
      )
    end


    delegate :created_by, :updated_by, to: :object_activity, allow_nil: true

    after_commit :log_object_activity, on: %i[create update], if: -> { modifier.present? }

    scope :left_joins_object_activities, lambda { |user_types|
      query = left_joins(:object_activity)
      user_types.each do |user_type|
        query = query.joins(left_join_users('created_by', user_type))
                     .joins(left_join_users('updated_by', user_type))
      end

      query
    }

    def self.left_join_users(action, user_type)
      "LEFT JOIN #{user_type.underscore.pluralize} AS #{action}_#{user_type.underscore.pluralize} " \
      "ON #{action}_#{user_type.underscore.pluralize}.id = object_activities.#{action}_id " \
      "AND object_activities.#{action}_type = '#{user_type}'"
    end

    private

    def log_object_activity
      object_activity              = ObjectActivity.find_or_initialize_by(trackable_object)
      object_activity.object_id    = id
      object_activity.created_by ||= modifier

      if object_activity.persisted?
        object_activity.updated_by = modifier
        object_activity.updated_at = Time.current
      end

      object_activity.save!
    end

    def trackable_object
      class_name = if self.class.fallback_to_base_class
                     self.class.base_class.name
                   else
                     self.class.name
                   end

      { object_id: send(self.class.trackable_column), object_type: class_name }
    end
  end
end
