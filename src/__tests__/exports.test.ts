import { describe, it, expect } from 'vitest';
import { ConektaTokenizer } from '../index';
import type {
  TokenizerConfig,
  TokenResult,
  TokenizerError,
  ConektaTokenizerProps,
} from '../index';

describe('Module exports', () => {
  it('exports ConektaTokenizer as a function component', () => {
    expect(ConektaTokenizer).toBeDefined();
    expect(typeof ConektaTokenizer).toBe('function');
  });

  it('types compile correctly', () => {
    // Type-level assertions: if any type is missing or wrong, this file won't compile.
    const config: TokenizerConfig = { publicKey: 'key_123' };
    const result: TokenResult = { token: 'tok_123', lastFour: '4242' };
    const error: TokenizerError = { type: 'ValidationError', message: 'invalid' };

    expect(config.publicKey).toBe('key_123');
    expect(result.token).toBe('tok_123');
    expect(error.type).toBe('ValidationError');
  });
});
