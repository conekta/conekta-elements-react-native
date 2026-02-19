import React, { useState } from 'react';
import { SafeAreaView, Text, StyleSheet } from 'react-native';
import { ConektaTokenizer } from 'conekta-elements-react-native';
import type { TokenResult, TokenizerError } from 'conekta-elements-react-native';

export default function App() {
  const [result, setResult] = useState<string>('');

  function handleSuccess(r: TokenResult) {
    setResult(`Token: ${r.token} (****${r.lastFour})`);
  }

  function handleError(e: TokenizerError) {
    setResult(`Error [${e.type}]: ${e.message}`);
  }

  return (
    <SafeAreaView style={styles.container}>
      <ConektaTokenizer
        config={{ publicKey: 'key_XXXXXXXXXXXXXXXX' }}
        onSuccess={handleSuccess}
        onError={handleError}
        style={styles.tokenizer}
      />
      {result ? <Text style={styles.result}>{result}</Text> : null}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1 },
  tokenizer: { flex: 1 },
  result: { padding: 16, fontSize: 14, color: 'green' },
});
