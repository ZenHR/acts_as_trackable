# acts_as_trackable Changelog
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
