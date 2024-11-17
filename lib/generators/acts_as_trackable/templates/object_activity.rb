class <%= class_name %> < ApplicationRecord
  self.record_timestamps = false

  belongs_to :updated_by, polymorphic: true, optional: true
  belongs_to :created_by, polymorphic: true
  belongs_to :object,     polymorphic: true
end
