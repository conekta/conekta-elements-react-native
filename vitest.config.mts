import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  resolve: {
    alias: {
      'react-native': path.resolve(__dirname, 'src/__tests__/__mocks__/react-native.ts'),
    },
  },
  test: {
    globals: true,
  },
});
