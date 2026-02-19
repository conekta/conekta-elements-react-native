# conekta-elements-react-native

React Native wrapper for [Conekta Elements](https://github.com/conekta/conekta-elements) — renders the native Compose UI directly on Android and iOS via a thin JavaScript bridge.

## Requirements

| Platform | Minimum version |
|----------|----------------|
| Android  | API 24 (Android 7.0) |
| iOS      | 14.0 |
| React Native | 0.71+ |

## Installation

This package is published to GitHub Packages. First, configure your `.npmrc` to use the GitHub registry for the `@conekta` scope:

```
@conekta:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=YOUR_GITHUB_TOKEN
```

Then install:

```bash
npm install @conekta/conekta-elements-react-native
```

### iOS

```bash
cd ios && pod install
```

`pod install` descarga automáticamente el XCFramework de Compose desde GitHub releases.

### Android

Autolinking registra el módulo automáticamente. No se requiere configuración adicional.

## Usage

```tsx
import React, { useState } from 'react';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ConektaTokenizer } from '@conekta/conekta-elements-react-native';
import type { TokenResult, TokenizerError } from '@conekta/conekta-elements-react-native';

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

This library uses native modules (Kotlin Multiplatform) and is **not compatible with Expo Go**.

Expo users must create a [development build](https://docs.expo.dev/develop/development-builds/introduction/):

```bash
npx expo install expo-dev-client
eas build --profile development
```

After that, autolinking will pick up the module automatically and the library works as usual.

## Development

Clona el repo y usa la app de ejemplo:

```bash
git clone https://github.com/conekta/conekta-elements-react-native.git
cd conekta-elements-react-native

npm install

# Android
cd example && npx react-native run-android

# iOS
cd example/ios && pod install && cd ..
npx react-native run-ios
```

## License

[MIT](./LICENSE)
