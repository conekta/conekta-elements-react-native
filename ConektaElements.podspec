require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))
elements = package['conektaElements']

Pod::Spec.new do |s|
  s.name    = "ConektaElements"
  s.version = package['version']
  s.summary = "React Native wrapper for Conekta Elements Compose UI"
  s.homepage = "https://github.com/conekta/conekta-elements-react-native"
  s.license  = { :type => "MIT" }
  s.author   = { "Conekta" => "engineering@conekta.com" }
  s.source   = { :git => "https://github.com/conekta/conekta-elements-react-native.git", :tag => s.version }

  s.ios.deployment_target = "14.0"
  s.swift_version = "5.9"

  s.dependency "React-Core"

  s.prepare_command = <<-CMD
    set -e
    curl -L \
         "https://github.com/conekta/conekta-elements/releases/download/#{elements['version']}/composeKit.xcframework.zip" \
         -o composeKit.xcframework.zip
    echo "#{elements['iosChecksum']}  composeKit.xcframework.zip" | shasum -a 256 -c -
    unzip -o composeKit.xcframework.zip
    rm     composeKit.xcframework.zip
  CMD

  s.vendored_frameworks = "composeKit.xcframework"
  s.source_files        = "ios/**/*.{swift,m,h}"
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.9" }

  # Copy Compose Multiplatform resources (fonts, strings) into the app bundle
  compose_resources_script = <<-SCRIPT
    FRAMEWORK_DIR="${BUILT_PRODUCTS_DIR}/composeKit.framework"
    if [ ! -d "$FRAMEWORK_DIR/composeResources" ]; then
      FRAMEWORK_DIR=$(find "${PODS_ROOT}/../" -path "*/composeKit.framework/composeResources" -maxdepth 8 2>/dev/null | head -1 | sed 's|/composeResources||')
    fi
    if [ -d "$FRAMEWORK_DIR/composeResources" ]; then
      DEST="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/compose-resources"
      mkdir -p "$DEST"
      cp -R "$FRAMEWORK_DIR/composeResources" "$DEST/"
      echo "Copied composeResources to $DEST"
    else
      echo "warning: composeResources not found in composeKit.framework"
    fi
  SCRIPT
  s.script_phase = {
    :name => 'Copy Compose Resources',
    :script => compose_resources_script,
    :execution_position => :after_compile
  }
end
