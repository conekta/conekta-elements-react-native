const path = require('path');

// Raíz del proyecto (example/); necesario cuando el CLI se ejecuta desde el repo root (p. ej. IDX).
const projectRoot = path.resolve(__dirname);

module.exports = {
  project: {
    android: {
      sourceDir: path.join(projectRoot, 'android'),
    },
  },
};
