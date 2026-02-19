Pod::Spec.new do |s|
  s.name    = "ConektaElements"
  s.version = "0.0.1-beta.12"
  s.summary = "React Native wrapper for Conekta Elements Compose UI"
  s.homepage = "https://github.com/conekta/conekta-elements"
  s.license  = { :type => "MIT" }
  s.author   = { "Conekta" => "engineering@conekta.com" }
  s.source   = { :git => "https://github.com/conekta/conekta-elements-react-native.git", :tag => s.version }

  s.ios.deployment_target = "14.0"
  s.swift_version = "5.9"

  s.dependency "React-Core"

  # Downloads the xcframework from a private GitHub release.
  # Requires ~/.netrc with GitHub credentials before running pod install:
  #
  #   printf "machine api.github.com login <user> password <token>\nmachine github.com login <user> password <token>\n" >> ~/.netrc
  #   chmod 600 ~/.netrc
  #
  s.prepare_command = <<-CMD
    ASSET_URL=$(curl -s --netrc \
      -H "Accept: application/vnd.github+json" \
      "https://api.github.com/repos/conekta/conekta-elements/releases/latest" \
      | grep -o '"url":"[^"]*composeKit\.xcframework\.zip[^"]*"' \
      | head -1 \
      | sed 's/"url":"//;s/"//')
    if [ -z "$ASSET_URL" ]; then
      echo "error: Could not find composeKit.xcframework.zip. Check ~/.netrc credentials."
      exit 1
    fi
    curl -L --netrc \
         -H "Accept: application/octet-stream" \
         "$ASSET_URL" \
         -o composeKit.xcframework.zip
    unzip -o composeKit.xcframework.zip
    rm     composeKit.xcframework.zip
  CMD

  s.vendored_frameworks = "composeKit.xcframework"
  s.source_files        = "ios/**/*.{swift,m,h}"
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.9" }
end
