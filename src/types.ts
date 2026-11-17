export interface TokenizerConfig {
  publicKey: string;
  merchantName?: string;
  /** The form's language; the device's when omitted. */
  locale?: TokenizerLocale;
  /** Card networks the form refuses; none by default. */
  excludeCardNetworks?: CardNetwork[];
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
  onSuccess: (result: TokenResult) => void;
  onError: (error: TokenizerError) => void;
  style?: import('react-native').StyleProp<import('react-native').ViewStyle>;
}
