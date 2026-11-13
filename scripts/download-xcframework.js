const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
const { version, iosChecksum } = pkg.conektaElements;

const xcframeworkDir = path.join(root, 'composeKit.xcframework');
const resourcesDir = path.join(root, 'compose-resources');
const zipPath = path.join(root, 'composeKit.xcframework.zip');

/** Downloads the SDK's XCFramework of this package's version and checks it against the pinned checksum. */
function downloadFramework() {
  const url = `https://github.com/conekta/conekta-components-ios/releases/download/${version}/composeKit.xcframework.zip`;
  console.log(`[ConektaElements] Downloading composeKit.xcframework (${version})...`);

  execSync(`curl -L "${url}" -o "${zipPath}"`, { stdio: 'inherit' });
  const result = execSync(`echo "${iosChecksum}  ${zipPath}" | shasum -a 256 -c -`, { encoding: 'utf8' });
  console.log(`[ConektaElements] Checksum: ${result.trim()}`);

  execSync(`unzip -o "${zipPath}" -d "${root}"`, { stdio: 'inherit' });
  fs.unlinkSync(zipPath);
  console.log('[ConektaElements] composeKit.xcframework downloaded successfully.');
}

/**
 * Puts the form's fonts where CocoaPods takes them from (the podspec's `resources`). The form looks for them
 * under `compose-resources/` in the app, and the resources of a static framework never get there by themselves.
 */
function exposeResources() {
  const source = path.join(xcframeworkDir, 'ios-arm64', 'composeKit.framework', 'composeResources');
  fs.rmSync(resourcesDir, { recursive: true, force: true });
  fs.cpSync(source, path.join(resourcesDir, 'composeResources'), { recursive: true });
}

try {
  if (fs.existsSync(xcframeworkDir)) {
    console.log('[ConektaElements] composeKit.xcframework already exists, skipping download.');
  } else {
    downloadFramework();
  }
  exposeResources();
} catch (err) {
  console.error('[ConektaElements] Failed to set up composeKit.xcframework:', err.message);
  if (fs.existsSync(zipPath)) fs.unlinkSync(zipPath);
  process.exit(1);
}
