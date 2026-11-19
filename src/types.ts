export interface TokenizerConfig {
  publicKey: string;
  merchantName?: string;
  /** The form's language; the device's when omitted. */
  locale?: TokenizerLocale;
  /** Card networks the form refuses; none by default. */
  excludeCardNetworks?: CardNetwork[];
  logoDisplay?: LogoDisplay;
}

export type LogoDisplay = 'inline' | 'none';

/** A preset the variables are written over: Conekta's own look, fields filled instead of outlined, or dark. */
export type AppearanceTheme = 'conekta' | 'flat' | 'night';

/**
 * The form's look. Colors are CSS hex (`'#FF7A00'`), sizes whole dp / pt. The theme is applied first, so a
 * variable written beside it wins; an omitted variable keeps the theme's value.
 */
export interface TokenizerAppearance {
  theme?: AppearanceTheme;
  /** The pay button and the focused field. */
  colorPrimary?: string;
  colorSelected?: string;
  colorBackground?: string;
  colorBannerBackground?: string;
  /** Titles and body text. */
  colorText?: string;
  colorTextSecondary?: string;
  /** Errors. */
  colorDanger?: string;
  borderColor?: string;
  borderRadius?: number;
  /**
   * A font family by name: one the app bundles (Android: a font resource; iOS: a family registered in
   * `UIAppFonts`) or one the device has. Conekta's own when omitted or not found.
   */
  fontFamily?: string;
  /** The label above each field. */
  colorLabel?: string;
  colorInputText?: string;
  colorInputBackground?: string;
  /** `borderColor` when omitted. */
  colorInputBorder?: string;
  inputBorderRadius?: number;
}

export type TokenizerLocale = 'es' | 'en';

export type CardNetwork = 'amex' | 'visa_master_card';

export interface TokenResult {
  token: string;
  lastFour: string;
}

export type TokenizerError =
  | { type: 'ValidationError'; message: string }
  | { type: 'NetworkError'; message: string }
  | { type: 'ApiError'; code: string; message: string };

export interface ConektaTokenizerProps {
  config: TokenizerConfig;
  appearance?: TokenizerAppearance;
  onSuccess: (result: TokenResult) => void;
  onError: (error: TokenizerError) => void;
  style?: import('react-native').StyleProp<import('react-native').ViewStyle>;
}
