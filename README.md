# conekta-elements-react-native

React Native wrapper for [Conekta Elements](https://github.com/conekta/conekta-elements) — renders the native Compose UI directly on Android and iOS via a thin JavaScript bridge.

## Requirements

| Platform | Minimum version |
|----------|----------------|
| Android  | API 24 (Android 7.0) |
| iOS      | 14.0 |
| React Native | 0.71+ |

## Installation

```bash
npm install conekta-elements-react-native
```

### iOS

```bash
cd ios && pod install
```

`pod install` descarga automáticamente el XCFramework de Compose desde GitHub releases.

### Android

Si tu proyecto **no usa autolinking**, registra el paquete manualmente en `MainApplication.kt`:

```kotlin
packages.add(ConektaTokenizerPackage())
```

## Usage

```tsx
import React, { useState } from 'react';
import { SafeAreaView } from 'react-native';
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
