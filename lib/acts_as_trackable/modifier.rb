require 'active_support/concern'

module Modifier
  extend ActiveSupport::Concern

  included do
    has_many :object_activities_as_updater, class_name: 'ObjectActivity', as: :updated_by
    has_many :object_activities_as_creator, class_name: 'ObjectActivity', as: :created_by
  end
end
