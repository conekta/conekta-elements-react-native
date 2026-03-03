module.exports = {
  dependency: {
    platforms: {
      ios: {
        scriptPhases: [
          {
            name: 'Copy Compose Resources',
            path: './scripts/copy-compose-resources.sh',
            execution_position: 'after_compile',
          },
        ],
      },
    },
  },
};
