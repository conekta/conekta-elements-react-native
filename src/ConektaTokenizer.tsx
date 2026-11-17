import React from 'react';
import { requireNativeComponent, NativeSyntheticEvent } from 'react-native';
import type { ConektaTokenizerProps, TokenResult, TokenizerError } from './types';

const NativeTokenizer = requireNativeComponent<any>('ConektaTokenizerView');

export function ConektaTokenizer({
  config,
  onSuccess,
  onError,
  style,
}: ConektaTokenizerProps) {
  return (
    <NativeTokenizer
      publicKey={config.publicKey}
      merchantName={config.merchantName ?? 'Demo Store'}
      locale={config.locale}
      excludeCardNetworks={config.excludeCardNetworks ?? []}
      onSuccess={(e: NativeSyntheticEvent<TokenResult>) => onSuccess(e.nativeEvent)}
      onError={(e: NativeSyntheticEvent<TokenizerError>) => onError(e.nativeEvent)}
      style={[{ flex: 1 }, style]}
    />
  );
}
