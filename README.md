[![Gem Version](https://badge.fury.io/rb/acts_as_trackable.svg)](https://badge.fury.io/rb/acts_as_trackable)

# ActsAsTrackable

ActsAsTrackable is a gem that simplifies the process of tracking your DB object's creation and modification.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_trackable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install acts_as_trackable

After that run the following commands:

    $ rails generate acts_as_trackable:object_activity ObjectActivity
    $ rails db:migrate

## Usage

- ActsAsTrackable is auto_loaded, there's no need to add it to ApplicationRecord.rb

- Go to your model and add the following:

  ```ruby
  acts_as_trackable
  ```

- If your model is expected to have multiple versions of each object, pass the column that tracks the version to acts_as_trackable as a symbol, acts_as_trackable is smart enough to relink the object_activity with the latest version(Previous versions won't be linked to any activity):

  ```ruby
  acts_as_trackable :latest_x_version_id
  ```

- Go to your user model and the following:
    ```ruby
    acts_as_modifier
    ```
- For STI models, set the following attribute to true to save the child class's object type as the parent class's (base_class) object type:
  ```ruby
  class Post < ActiveRecord::Base
  self.inheritance_column = :class_name

    acts_as_trackable
  end

  class Comment < Post
    acts_as_trackable fallback_to_base_class: true
  end
  ```
- After that, you need to pass the user to the modifier attribute from your controller(or basically anywhere) to your update/create statements as follows(If you don't pass the modifier, track me will simply ignore creating/updating the object activity):
  ```ruby
  YourTrackableModel.update(modifier: @current_user)
  ```


- Joining your records with objects_activities for Sorting, Searching, and Filtering:
  ```ruby
  @records.left_joins_object_activities(['YourUserModelClassName'])
  ```


- Fetching an object's owners/modifiers:
  ```ruby
  @record.created_by
  @record.updated_by
  ```

- Fetching object_activities created/updated by user:
  ```ruby
  @user.object_activities_as_creator
  @user.object_activities_as_updater
  ```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a-keewan/acts_as_trackable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/acts_as_trackable/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActsAsTrackable project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/a-keewan/acts_as_trackable/blob/master/CODE_OF_CONDUCT.md).
