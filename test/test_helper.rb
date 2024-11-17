require 'bundler/setup'
require 'active_record'
require 'minitest/autorun'
require 'acts_as_trackable'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :posts, force: true do |t|
    t.string :title
    t.references :modifier, polymorphic: true
  end

  create_table :object_activities, force: true do |t|
    t.references :updated_by, polymorphic: true
    t.references :created_by, polymorphic: true
    t.references :object, polymorphic: true
    t.datetime   :updated_at
  end
end

class User < ActiveRecord::Base
  acts_as_modifier
end

class Post < ActiveRecord::Base
  acts_as_trackable
end

class ObjectActivity < ActiveRecord::Base
  self.record_timestamps = false

  belongs_to :updated_by, polymorphic: true, optional: true
  belongs_to :created_by, polymorphic: true
  belongs_to :object,     polymorphic: true
end
