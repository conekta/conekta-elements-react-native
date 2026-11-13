const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const pkgPath = path.resolve(__dirname, '..', 'package.json');
const pkg = JSON.parse(fs.readFileSync(pkgPath, 'utf8'));
const { version, iosChecksum } = pkg.conektaElements;

const xcframeworkDir = path.resolve(__dirname, '..', 'composeKit.xcframework');
const zipPath = path.resolve(__dirname, '..', 'composeKit.xcframework.zip');

if (fs.existsSync(xcframeworkDir)) {
  console.log('[ConektaElements] composeKit.xcframework already exists, skipping download.');
  process.exit(0);
}

const url = `https://github.com/conekta/conekta-components-ios/releases/download/${version}/composeKit.xcframework.zip`;

console.log(`[ConektaElements] Downloading composeKit.xcframework (${version})...`);

try {
  execSync(`curl -L "${url}" -o "${zipPath}"`, { stdio: 'inherit' });

  const result = execSync(`echo "${iosChecksum}  ${zipPath}" | shasum -a 256 -c -`, {
    encoding: 'utf8',
  });
  console.log(`[ConektaElements] Checksum: ${result.trim()}`);

  execSync(`unzip -o "${zipPath}" -d "${path.resolve(__dirname, '..')}"`, { stdio: 'inherit' });
  fs.unlinkSync(zipPath);

  console.log('[ConektaElements] composeKit.xcframework downloaded successfully.');
} catch (err) {
  console.error('[ConektaElements] Failed to download composeKit.xcframework:', err.message);
  // Clean up on failure
  if (fs.existsSync(zipPath)) fs.unlinkSync(zipPath);
  process.exit(1);
}
