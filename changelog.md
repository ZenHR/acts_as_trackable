# acts_as_trackable Changelog
## Version: 0.4.8
  ### Patch
    - Removed unused `generator_spec` development dependency, eliminating unnecessary transitive dependencies (railties, actionpack, nokogiri, rack, loofah, etc.).
    - Removed redundant `activesupport` declaration from Gemfile (already pulled in by activerecord).
    - Resolves GHSA-wx95-c6cv-8532 (nokogiri) by removing nokogiri from the dependency tree entirely.

## Version: 0.4.7
  ### Patch
    - Security Fix: Upgraded Rack dependency from 3.1.18 to 3.1.20 to patch CVE-2026-22860 and CVE-2026-25500.

## Version: 0.4.6
  ### Patch
    - Security Fix: Upgraded Rack dependency from 3.1.17 to 3.1.18 to patch CVE-2025-27610.

## Version: 0.4.5
  ### Patch
    - Security Fix: Upgraded Rack dependency from 3.1.16 to 3.1.17 to patch CVE-2025-61771.
    - Housekeeping: Removed old gem files from version control.

## Version: 0.4.4
  ### Patch
    - Critical Fix: Properly cache `nil` when `object_activity` is preloaded but doesn't exist (old records).
    - Prevents N+1 queries when accessing `created_by`/`updated_by` on records without `object_activity`.
    - Previously, the fallback query would execute for each record even when using `includes(object_activity: [:created_by, :updated_by])`.
    - Now correctly returns `nil` without database queries when association is preloaded and empty.

## Version: 0.4.3
  ### Patch
    - Performance Fix: Fixed N+1 query issue when accessing `created_by` and `updated_by` after eager loading.

    - The `created_by` and `updated_by` methods now properly respect preloaded associations.
    - When using `includes(object_activity: [:created_by, :updated_by])` or `Preloader.new(records: records, associations: { object_activity: %i[created_by updated_by] })`, the methods now use the preloaded data instead of triggering additional database queries.

    - Added comprehensive test coverage for N+1 query prevention scenarios.
    - Migration Note: This is a non-breaking change. Existing code will continue to work, but performance will improve when using nested eager loading.
## Version: 0.4.2
  ### Patch
    - Upgraded dependencies to patch CVE-2025-55193.
## Version: 0.4.1
  ### Patch
    - Upgraded dependencies to patch CVE-2025-6021, CVE-2025-6170, CVE-2025-49794, CVE-2025-49795, CVE-2025-49796, and CVE-2025-54314.
## Version: 0.4.0
  ### Minor
    - Performance Improvement: The `object_activity` method now memoizes results.
    - Migration Required: Replace `Preloader` calls with `includes(:object_activity)` for bulk loading.
## Version: 0.3.5
  ### Patch
    - Upgraded dependencies to patch CVE-2022-44571
## Version: 0.3.4
  ### Patch
    - Upgraded dependencies to patch CVE-2025-46336
## Version: 0.3.3
  ### Patch
    - Upgraded dependencies to patch CVE-2025-46727
## Version: 0.3.2
  ### Patch
    - Upgraded dependencies to patch CVE-2025-32414 and CVE-2025-32415
## Version: 0.3.1
  ### Patch
    - Updated README
## Version: 0.3.0
  ### Patch
    - Added support to treat STI models as one model
    - Upgraded dependencies to patch CVE-2025-24855 and CVE-2024-55549
## Version: 0.2.5
  ### Patch
    - Upgraded dependencies to patch CVE-2025-27111 and CVE-2025-27610
## Version: 0.2.4
  ### Patch
    - Upgraded dependencies to patch CVE-2025-24928 and CVE-2024-56171
## Version: 0.2.3
  ### Patch
    - Upgraded dependencies to patch https://nvd.nist.gov/vuln/detail/CVE-2025-25184
## Version: 0.2.2
  ### Patch
    - Upgraded dependencies to patch https://security.snyk.io/vuln/SNYK-RUBY-ACTIONPACK-8496389
## Version: 0.2.1
  ### Patch
    - Upgraded dependencies to patch https://github.com/rails/rails-html-sanitizer/security/advisories/GHSA-rxv5-gxqc-xx8g
## Version: 0.2.0
  ### Patch
    - Upgraded all used dependencies to patch https://github.com/advisories/GHSA-vv62-jfwq-693v mainly caused by using nokogiri
    - Increased required_ruby_version to >= 3.1.2
## Version: 0.1.1
  ### Fix:
    - Replaced user_type.downcase with user_type.underscore to support joining with user classes consisting of more than word.
    - Added how-to access objects steps to the README file.
## Version: 0.1.0
