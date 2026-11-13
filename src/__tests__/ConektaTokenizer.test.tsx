import { describe, it, expect, vi } from 'vitest';
import React from 'react';
import renderer from 'react-test-renderer';
import { ConektaTokenizer } from '../ConektaTokenizer';

const defaultProps = {
  config: { publicKey: 'key_test_123' },
  onSuccess: vi.fn(),
  onError: vi.fn(),
};

describe('ConektaTokenizer', () => {
  it('renders successfully', () => {
    const tree = renderer.create(<ConektaTokenizer {...defaultProps} />);
    expect(tree.toJSON()).toMatchSnapshot();
  });

  it('passes publicKey to native component', () => {
    const tree = renderer.create(<ConektaTokenizer {...defaultProps} />);
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.publicKey).toBe('key_test_123');
  });

  it('defaults merchantName to "Demo Store"', () => {
    const tree = renderer.create(<ConektaTokenizer {...defaultProps} />);
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.merchantName).toBe('Demo Store');
  });

  it('passes custom merchantName when provided', () => {
    const tree = renderer.create(
      <ConektaTokenizer
        {...defaultProps}
        config={{ publicKey: 'key_test_123', merchantName: 'My Store' }}
      />
    );
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.merchantName).toBe('My Store');
  });

  it('leaves the locale to the device and excludes no network by default', () => {
    const tree = renderer.create(<ConektaTokenizer {...defaultProps} />);
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.locale).toBeUndefined();
    expect(root.props.excludeCardNetworks).toEqual([]);
  });

  it('passes locale and excludeCardNetworks when provided', () => {
    const tree = renderer.create(
      <ConektaTokenizer
        {...defaultProps}
        config={{ publicKey: 'key_test_123', locale: 'en', excludeCardNetworks: ['amex'] }}
      />
    );
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.locale).toBe('en');
    expect(root.props.excludeCardNetworks).toEqual(['amex']);
  });

  it('unwraps nativeEvent on onSuccess callback', () => {
    const onSuccess = vi.fn();
    const tree = renderer.create(
      <ConektaTokenizer {...defaultProps} onSuccess={onSuccess} />
    );
    const root = tree.root.findByType('ConektaTokenizerView' as any);

    // Simulate the native event structure
    root.props.onSuccess({ nativeEvent: { token: 'tok_123', lastFour: '4242' } });

    expect(onSuccess).toHaveBeenCalledWith({
      token: 'tok_123',
      lastFour: '4242',
    });
  });

  it('unwraps nativeEvent on onError callback', () => {
    const onError = vi.fn();
    const tree = renderer.create(
      <ConektaTokenizer {...defaultProps} onError={onError} />
    );
    const root = tree.root.findByType('ConektaTokenizerView' as any);

    root.props.onError({
      nativeEvent: { type: 'NetworkError', message: 'timeout' },
    });

    expect(onError).toHaveBeenCalledWith({
      type: 'NetworkError',
      message: 'timeout',
    });
  });

  it('applies flex: 1 as base style', () => {
    const tree = renderer.create(<ConektaTokenizer {...defaultProps} />);
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.style).toContainEqual({ flex: 1 });
  });

  it('merges custom style with base style', () => {
    const tree = renderer.create(
      <ConektaTokenizer {...defaultProps} style={{ height: 400 }} />
    );
    const root = tree.root.findByType('ConektaTokenizerView' as any);
    expect(root.props.style).toContainEqual({ flex: 1 });
    expect(root.props.style).toContainEqual({ height: 400 });
  });
});
