# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2026-03-03

First stable release of `conekta-elements-react-native` on the public npm registry.

### Added

- `<ConektaTokenizer />` component that renders the native Conekta Elements Compose UI on Android and iOS
- Automatic XCFramework download via `postinstall` script for iOS
- Android autolinking support (no manual configuration required)
- TypeScript types for `TokenizerConfig`, `TokenResult`, and `TokenizerError`
- Expo development build compatibility (Expo Go is not supported)
- CI workflow for publishing to npm on GitHub releases
- PR validation workflow with type checking

