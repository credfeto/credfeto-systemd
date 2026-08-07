# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Please ADD ALL Changes to the UNRELEASED SECTION and not a specific release
-->

## [Unreleased]
### Security
### Added
- Added .ai-instructions and ai/local/index.md from cs-template standard
- Local firejail override for shellcheck to allow bats/pre-commit test fixtures in /run/user/<uid> and /tmp
- Render /etc/ssh/sshd_config.d/14_KeyServer.conf at install time with the per-machine hostname baked in, enabling AuthorizedKeysCommand lookups against the central key server
### Fixed
- Fixed missing trailing newlines in units/auto-update scripts
- Removed tracked .idea/.gitignore file that was already in .gitignore
- Use sudo when removing root-owned sysctl config files installed by the install script
- Fixed install script failing with "hostname: not found" on Arch by using hostnamectl --static instead of the hostname command, which also preserves the full configured hostname (e.g. local domain suffix) instead of truncating it
### Changed
- Refactored install script into named functions for readability and easier future extraction into separate install.d/ scripts
### Deprecated
### Removed
- Removed yay and paru AUR helpers from install script; direct AUR package installs are prohibited
### Deployment Changes
<!--
Releases that have at least been deployed to staging, BUT NOT necessarily released to live.  Changes should be moved from [Unreleased] into here as they are merged into the appropriate release branch
-->
## [0.0.0] - Project created