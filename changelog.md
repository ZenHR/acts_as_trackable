# acts_as_trackable Changelog

## Version: 0.2.0
  ### Patch
    - Upgraded all used dependencies to patch https://github.com/advisories/GHSA-vv62-jfwq-693v mainly caused by using nokogiri
    - Increased required_ruby_version to >= 3.1.2
## Version: 0.1.1
  ### Fix:
    - Replaced user_type.downcase with user_type.underscore to support joining with user classes consisting of more than word.
    - Added how-to access objects steps to the README file.
## Version: 0.1.0
