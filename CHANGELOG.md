# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-11-13

### Changed

- Uses Conekta Components 1.2.2, from Maven Central (Android) and `conekta/conekta-components-ios` (iOS)
- iOS: the form's resources now reach the app through the podspec (`resources`) and the `postinstall` script, which copy them out of the XCFramework into `compose-resources/`; `react-native.config.js` and its copy script no longer exist. Run `pod install` again after updating
- **Breaking**: minimum React Native 0.81 (Android `compileSdk` 36, Android Gradle Plugin 8.9.1, Kotlin 2.1) and iOS 15.0; the iOS framework is arm64 only (devices and Apple silicon simulators)
- iOS: `CADisableMinimumFrameDurationOnPhone` in the app's `Info.plist` is recommended (120 Hz screens); the form opens without it

### Added

- `config.locale` (`'es' | 'en'`): the form's language, the device's by default
- `config.excludeCardNetworks` (`'amex' | 'visa_master_card'`): card networks the form refuses

### Fixed

- iOS: `onSuccess` / `onError` are direct events; the form no longer fails to mount
- iOS: the form is rebuilt only when a `config` value changes; a re-render with the same values no longer clears what the shopper had typed
- iOS: the form is removed from its parent view controller when the component unmounts, so Compose closes its lifecycle
- iOS: the form's resources are copied into the app (see Changed)
- Android: `onSuccess` / `onError` are sent through React Native's event dispatcher instead of the deprecated `RCTEventEmitter`; every result reaches JS, none is merged with another

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

