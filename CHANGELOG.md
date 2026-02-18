# Changelog

All notable changes to the Specman Syntax Highlighter will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- CI workflow for PR validation (build + tests)
- Automated release workflow (tag, GitHub Release, Marketplace publish)
- npm scripts for build, test, package, and release
- `.vscodeignore` for clean extension packaging

### Changed
- Rewritten README and added CONTRIBUTING guide
- Devcontainer uses `pipx` for Python CLI tools

### Fixed
- Multiple syntax bugs based on Specman reference (#4)

## [0.2.11] - 2023-06-07

### Fixed
- Fix check statements

## [0.2.10] - 2023-06-07

### Fixed
- Fix check statements

## [0.2.9] - 2023-03-23

### Fixed
- Fix methods detection (#3)

## [0.2.8] - 2023-03-13

### Fixed
- Fix failing tests on constraints (#2)
- Change order between comparison and assignment operators
- Fix type misdetection
- Fix standard constraints
- Fix meta class declaration leaking to body
- Fix beginning of comments
- Don't use lookahead semantics for methods

### Added
- Additional test cases for constraints and built-in functions

## [0.2.7] - 2023-02-20

### Added
- Built-in functions
- Constraint expressions
- Support for strings

## [0.2.6] - 2023-02-16

_No notable changes._

## [0.2.5] - 2023-02-16

### Added
- Preprocessor support
- Struct allocation and variable declaration
- Inline generation
- Code blocks
- Pre-commit hooks and vsce to devcontainer

### Fixed
- Bad comments handling

## [0.2.4] - 2023-02-07

### Added
- Licensing and `extensionKind` configuration

## [0.2.3] - 2023-02-07

### Added
- Checks, constraint definitions, and default scopes
- Scalar types
- Built-in variables
- Operators
- Priority scopes, literals, and template params

## [0.2.2] - 2023-02-06

### Fixed
- Update path to repository

## [0.2.1] - 2023-02-06

### Added
- Member declarations with tests

## [0.2.0] - 2023-01-25

### Added
- Struct declarations
- Import support
- Package pattern
- Comments with tests
- Template support
- Macro support

### Fixed
- Comment block handling

## [0.0.1] - 2023-01-19

### Added
- Initial release
- TextMate grammar for Specman (e) language
- Build script with Jinja2 template support
- Grammar test infrastructure

[Unreleased]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.11...HEAD
[0.2.11]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.10...v0.2.11
[0.2.10]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.9...v0.2.10
[0.2.9]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.8...v0.2.9
[0.2.8]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.7...v0.2.8
[0.2.7]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.6...v0.2.7
[0.2.6]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.5...v0.2.6
[0.2.5]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.4...v0.2.5
[0.2.4]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.3...v0.2.4
[0.2.3]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.2...v0.2.3
[0.2.2]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/tsvi/specman-vscode-grammar/compare/v0.0.1...v0.2.0
[0.0.1]: https://github.com/tsvi/specman-vscode-grammar/releases/tag/v0.0.1
