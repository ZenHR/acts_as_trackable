require_relative 'lib/acts_as_trackable/version'

Gem::Specification.new do |spec|
  spec.name                        = 'acts_as_trackable'
  spec.version                     = ActsAsTrackable::VERSION
  spec.authors                     = ['Ahmad Keewan', 'ZenHR Engineering']
  spec.email                       = ['a.keewan@zenhr.com']
  spec.homepage                    = 'https://www.zenhr.com'
  spec.license                     = 'MIT'
  spec.required_ruby_version       = Gem::Requirement.new('>= 2.7.2')
  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/a-keewan/acts_as_trackable'
  spec.metadata["changelog_uri"]   = 'https://github.com/a-keewan/acts_as_trackable/blob/master/changelog.md'

  spec.summary = <<~DESC
    ActsAsTrackable is a RoR gem that simplifies tracking the creation and modification of database objects.
    It provides easy-to-use methods to make any ActiveRecord model trackable
    and allows tracking of modifications by specific users.
  DESC
  spec.description = <<~DESC
    ActsAsTrackable is designed to simplify the process of tracking database object activities in Ruby on Rails applications.
    By including the gem and running a few setup commands, developers can make their models trackable with minimal effort.
    The gem supports tracking multiple versions of objects and associating activities with specific users.
    It is auto-loaded into ActiveRecord, eliminating the need for manual inclusion in models.
    ActsAsTrackable also provides methods for joining records with their associated activities,
    making it easier to query and analyze object changes.
  DESC

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) || f.end_with?('.gem') }
  end

  spec.add_development_dependency 'generator_spec'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
