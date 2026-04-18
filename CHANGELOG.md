# Changelog

## [3.0.0] - 18/Apr/2026

Major release with breaking changes.

## [2.0.4] - 18/Apr/2026

Republished package from the reset repository history.

## [1.0.0] - 18/Apr/2026

Initial release of the current `mpesa_sdk_mz` base.

### Added

- Explicit environment configuration for `sandbox` and `production`
- Dedicated client configuration and credential types
- Typed request and response models aligned with the current package API
- Support for `C2B`, `B2C`, `B2B`, `Reversal`, `Transaction Status`, and `Query Customer Masked Name`
- Automated tests for request construction and response parsing

### Changed

- Adopted an instance-based client API
- Made `Origin` explicit in configuration
- Removed automatic console logging from transaction methods
