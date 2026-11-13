import { describe, it, expect, vi } from 'vitest';
import { ConektaTokenizer } from '../ConektaTokenizer';
import type { ConektaTokenizerProps } from '../types';

const defaultProps: ConektaTokenizerProps = {
  config: { publicKey: 'key_test_123' },
  onSuccess: vi.fn(),
  onError: vi.fn(),
};

/**
 * The native view the component renders for [props], as the element it returns: the component is a plain
 * function of its props, so nothing has to be mounted to read what it hands the native side.
 */
function nativeView(props: Partial<ConektaTokenizerProps> = {}) {
  return ConektaTokenizer({ ...defaultProps, ...props });
}

describe('ConektaTokenizer', () => {
  it('renders successfully', () => {
    expect(nativeView()).toMatchSnapshot();
  });

  it('passes publicKey to native component', () => {
    const root = nativeView();
    expect(root.props.publicKey).toBe('key_test_123');
  });

  it('defaults merchantName to "Demo Store"', () => {
    const root = nativeView();
    expect(root.props.merchantName).toBe('Demo Store');
  });

  it('passes custom merchantName when provided', () => {
    const root = nativeView({ config: { publicKey: 'key_test_123', merchantName: 'My Store' } });
    expect(root.props.merchantName).toBe('My Store');
  });

  it('leaves the locale to the device and excludes no network by default', () => {
    const root = nativeView();
    expect(root.props.locale).toBeUndefined();
    expect(root.props.excludeCardNetworks).toEqual([]);
  });

  it('passes locale and excludeCardNetworks when provided', () => {
    const root = nativeView({ config: { publicKey: 'key_test_123', locale: 'en', excludeCardNetworks: ['amex'] } });
    expect(root.props.locale).toBe('en');
    expect(root.props.excludeCardNetworks).toEqual(['amex']);
  });

  it('unwraps nativeEvent on onSuccess callback', () => {
    const onSuccess = vi.fn();
    const root = nativeView({ onSuccess: onSuccess });

    // Simulate the native event structure
    root.props.onSuccess({ nativeEvent: { token: 'tok_123', lastFour: '4242' } });

    expect(onSuccess).toHaveBeenCalledWith({
      token: 'tok_123',
      lastFour: '4242',
    });
  });

  it('unwraps nativeEvent on onError callback', () => {
    const onError = vi.fn();
    const root = nativeView({ onError: onError });

    root.props.onError({
      nativeEvent: { type: 'NetworkError', message: 'timeout' },
    });

    expect(onError).toHaveBeenCalledWith({
      type: 'NetworkError',
      message: 'timeout',
    });
  });

  it('applies flex: 1 as base style', () => {
    const root = nativeView();
    expect(root.props.style).toContainEqual({ flex: 1 });
  });

  it('merges custom style with base style', () => {
    const root = nativeView({ style: { height: 400 } });
    expect(root.props.style).toContainEqual({ flex: 1 });
    expect(root.props.style).toContainEqual({ height: 400 });
  });
});
