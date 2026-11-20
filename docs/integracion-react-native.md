# Integración en React Native

El SDK de React Native proporciona un wrapper que renderiza directamente la UI nativa de Conekta Components en Android e iOS a través de un puente JavaScript ligero.

## Requisitos

| Plataforma   | Versión mínima       |
|--------------|----------------------|
| Android      | API 24 (Android 7.0) |
| iOS          | 15.0 (dispositivos y simuladores arm64) |
| React Native | 0.81+                |

> ⚠️ **Indispensable**: Necesitas una **llave pública de Conekta** para utilizar el SDK.

> 📘 **Expo Go no es compatible.** Es una app sandboxed con un conjunto fijo de módulos nativos. Usa un [Development Build](https://docs.expo.dev/develop/development-builds/introduction/) o el workflow Bare.

## Paso 1: Instalar la dependencia

```bash
npm install conekta-elements-react-native
```

### iOS

Después de instalar, ejecuta:

```bash
cd ios && pod install
```

`npm install` ya descargó el XCFramework del SDK y sus recursos (el script `postinstall` del paquete, verificado
contra un checksum fijo); `pod install` los enlaza. Si el script no se ejecutó, el build de iOS falla: pasa
cuando instalas con `--ignore-scripts`, o con pnpm 10+ o Bun, que no ejecutan los scripts de instalación de una
dependencia a menos que los permitas. En ese caso ejecuta
`node node_modules/conekta-elements-react-native/scripts/download-xcframework.js` antes de `pod install`.

El formulario se dibuja con Compose Multiplatform. Agrega esta clave al `Info.plist` de tu app para que un iPhone
con pantalla de 120 Hz lo dibuje a su frecuencia completa; sin ella el formulario funciona, a 60 Hz:

```xml
<key>CADisableMinimumFrameDurationOnPhone</key>
<true/>
```

### Android

El autolinking registra el módulo automáticamente. La app debe compilar con `compileSdk` 36, Android Gradle Plugin 8.9.1 y Kotlin 2.1 o superior, lo que React Native 0.81 ya cumple.

## Paso 2: Implementar el tokenizador

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

## Componente `<ConektaTokenizer />`

| Prop | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| `config` | `TokenizerConfig` | Sí | Llave pública y configuración del comercio |
| `appearance` | `TokenizerAppearance` | No | Apariencia del formulario; la de Conekta si se omite |
| `onSuccess` | `(result: TokenResult) => void` | Sí | Se ejecuta cuando la tokenización es exitosa |
| `onError` | `(error: TokenizerError) => void` | Sí | Se ejecuta cuando la tokenización falla |
| `style` | `StyleProp<ViewStyle>` | No | Estilo del contenedor |

## Parámetros de configuración

| Parámetro | Tipo | Requerido | Default | Descripción |
|-----------|------|-----------|---------|-------------|
| `publicKey` | `string` | Sí | — | Llave pública de Conekta |
| `merchantName` | `string` | No | `"Demo Store"` | Nombre del comercio mostrado en el formulario |
| `locale` | `'es' \| 'en'` | No | Idioma del dispositivo | Idioma del formulario |
| `excludeCardNetworks` | `('amex' \| 'visa_master_card')[]` | No | `[]` | Redes de tarjeta que el formulario rechaza |
| `logoDisplay` | `'inline' \| 'none'` | No | `'inline'` | Si se muestra el encabezado de Conekta (su logo) sobre el formulario |

## Apariencia

```tsx
<ConektaTokenizer
  config={{ publicKey: 'key_xxx', logoDisplay: 'none' }}
  appearance={{ theme: 'night', colorPrimary: '#FF7A00', inputBorderRadius: 12, fontFamily: 'Poppins' }}
  onSuccess={onSuccess}
  onError={onError}
/>
```

Los colores son hex de CSS y las medidas dp / pt enteros. El tema se aplica primero: una variable escrita junto a él
gana sobre el valor del tema.

| Variable | Tipo | Descripción |
|----------|------|-------------|
| `theme` | `'conekta' \| 'flat' \| 'night'` | Preset: el de Conekta, campos rellenos u oscuro |
| `colorPrimary` | `string` | El botón y el campo enfocado |
| `colorSelected` | `string` | Una opción seleccionada |
| `colorBackground` | `string` | Fondo del formulario |
| `colorBannerBackground` | `string` | Fondo de los avisos |
| `colorText` | `string` | Títulos y texto |
| `colorTextSecondary` | `string` | Ayudas y texto secundario |
| `colorDanger` | `string` | Errores |
| `borderColor` | `string` | Bordes |
| `borderRadius` | `number` | Radio de las esquinas del botón y las superficies |
| `fontFamily` | `string` | Familia tipográfica por nombre, incluida en la app o instalada en el dispositivo; la de Conekta si no se encuentra |
| `colorLabel` | `string` | La etiqueta sobre cada campo |
| `colorInputText` | `string` | Lo que escribe el comprador |
| `colorInputBackground` | `string` | Relleno de un campo |
| `colorInputBorder` | `string` | Borde de un campo; `borderColor` si se omite |
| `inputBorderRadius` | `number` | Radio de las esquinas de un campo |

En iOS, un valor de `appearance` o de `config` que cambia vuelve a construir el formulario, vacío: defínelos antes de
que el comprador escriba.

## Respuesta exitosa

Cuando el usuario completa el formulario y la tokenización es exitosa, el callback `onSuccess` recibe un objeto `TokenResult`:

```typescript
interface TokenResult {
  token: string;     // Token de la tarjeta
  lastFour: string;  // Últimos cuatro dígitos de la tarjeta
}
```

## Manejo de errores

El callback `onError` recibe un objeto `TokenizerError` que puede ser uno de los siguientes tipos:

```typescript
type TokenizerError =
  | { type: 'ValidationError'; message: string }  // Error de validación del formulario
  | { type: 'NetworkError'; message: string }      // Error de conectividad
  | { type: 'ApiError'; code: string; message: string }  // Error de la API de Conekta
```

## Compatibilidad con Expo

| Workflow          | Compatible |
|-------------------|------------|
| Expo Go           | ❌ No      |
| Development Build | ✅ Sí      |
| Bare workflow     | ✅ Sí      |
| EAS Build         | ✅ Sí      |

Para usar con Expo, crea un Development Build:

```bash
npx expo install expo-dev-client

# Build local
npx expo run:ios
npx expo run:android

# O build con EAS
eas build --profile development
```
