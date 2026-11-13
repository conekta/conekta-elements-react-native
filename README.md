# conekta-elements-react-native

React Native wrapper for Conekta Components — renders the native Compose UI directly on Android and iOS via a thin JavaScript bridge.

## Requirements

| Platform | Minimum version |
|----------|----------------|
| Android  | API 24 (Android 7.0) |
| iOS      | 15.0 (arm64 devices and simulators) |
| React Native | 0.81+ |

## Installation

```bash
npm install conekta-elements-react-native
```

### iOS

```bash
cd ios && pod install
```

`npm install` already downloaded the SDK's XCFramework and its fonts (the package's `postinstall` script, checked
against a pinned checksum); `pod install` links them. If you install with `--ignore-scripts`, run
`node node_modules/conekta-elements-react-native/scripts/download-xcframework.js` before `pod install`.

The form is drawn with Compose Multiplatform. Add this key to your app's `Info.plist` so an iPhone with a
120 Hz screen draws it at its full refresh rate; without it the form works, at 60 Hz:

```xml
<key>CADisableMinimumFrameDurationOnPhone</key>
<true/>
```

### Android

Autolinking registers the module automatically. The app must build with `compileSdk` 36, Android Gradle Plugin 8.9.1 and Kotlin 2.1 or newer, which React Native 0.81 already does.

## Usage

```tsx
import React, { useState } from 'react';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ConektaTokenizer } from 'conekta-elements-react-native';
import type { TokenResult, TokenizerError } from 'conekta-elements-react-native';

export default function CheckoutScreen() {
  const [token, setToken] = useState('');

  function handleSuccess(result: TokenResult) {
    console.log('Token:', result.token, 'Last four:', result.lastFour);
    setToken(result.token);
  }

  function handleError(error: TokenizerError) {
    console.error(`[${error.type}] ${error.message}`);
  }

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <ConektaTokenizer
        config={{
          publicKey: 'key_XXXXXXXXXXXXXXXX',
          merchantName: 'Mi Tienda',
        }}
        onSuccess={handleSuccess}
        onError={handleError}
        style={{ flex: 1 }}
      />
    </SafeAreaView>
  );
}
```

## API

### `<ConektaTokenizer />`

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `config` | `TokenizerConfig` | Yes | Public key and merchant settings |
| `onSuccess` | `(result: TokenResult) => void` | Yes | Called when tokenization succeeds |
| `onError` | `(error: TokenizerError) => void` | Yes | Called when tokenization fails |
| `style` | `StyleProp<ViewStyle>` | No | View style |

### `TokenizerConfig`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `publicKey` | `string` | — | Conekta public key |
| `merchantName` | `string` | `"Demo Store"` | Merchant name shown in the UI |
| `locale` | `'es' \| 'en'` | device language | Language of the form |
| `excludeCardNetworks` | `('amex' \| 'visa_master_card')[]` | `[]` | Card networks the form refuses |

### `TokenResult`

```ts
{ token: string; lastFour: string }
```

### `TokenizerError`

```ts
| { type: 'ValidationError'; message: string }
| { type: 'NetworkError';    message: string }
| { type: 'ApiError'; code: string; message: string }
```

## Expo

This library contains native code and has the following compatibility:

| Expo workflow | Compatible |
|---------------|-----------|
| Expo Go | No |
| Development Build | Yes |
| Bare workflow | Yes |
| EAS Build | Yes |

**Expo Go is not supported.** It is a sandboxed app with a fixed set of native modules and cannot load custom native code.

To use this library with Expo, create a [development build](https://docs.expo.dev/develop/development-builds/introduction/):

```bash
npx expo install expo-dev-client

# Build locally
npx expo run:ios
npx expo run:android

# Or build with EAS
eas build --profile development
```

After that, autolinking picks up the module automatically and the library works as usual.

## Development

```bash
git clone https://github.com/conekta/conekta-elements-react-native.git
cd conekta-elements-react-native
npm install
```

Node 22.12 or newer (`.nvmrc`).

### Scripts

```bash
npm test          # Run tests
npm run test:watch # Run tests in watch mode
npx tsc --noEmit  # Type check
```

To check the Android bridge compiles: `cd android && ./gradlew assembleRelease`.

## License

[MIT](./LICENSE)
