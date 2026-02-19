const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const path = require('path');

const libSrc = path.resolve(__dirname, '../src');

const config = {
  // Watch only the library src/ so Metro picks up changes without scanning node_modules
  watchFolders: [libSrc],

  resolver: {
    // Resolve peer deps (react, react-native) from example/node_modules
    // to avoid duplicate instances when the library imports them
    extraNodeModules: new Proxy(
      {},
      {
        get: (_, name) =>
          path.join(__dirname, 'node_modules', String(name)),
      }
    ),
  },
};

module.exports = mergeConfig(getDefaultConfig(__dirname), config);
