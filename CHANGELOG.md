# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `TagLib::FLAC::File` and `TagLib::FLAC::Picture` classes -- extracting the
  pictures of a FLAC file works now

### Changed
- `TagLib::FileRef#file` now returns an instance of a more concrete subclass of
  `TagLib::File` if one is available

## [0.1.0] - 2020-03-27
### Added
- Initial release, supporting only the basic functionality of TagLib's C++
  library

[Unreleased]: https://github.com/nilsding/taglib.cr/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/nilsding/taglib.cr/releases/tag/v0.1.0
