Pod::Spec.new do |s|
  s.name    = "ConektaElements"
  s.version = "0.0.1-beta.7"
  s.summary = "React Native wrapper for Conekta Elements Compose UI"
  s.homepage = "https://github.com/conekta/conekta-elements"
  s.license  = { :type => "MIT" }
  s.author   = { "Conekta" => "engineering@conekta.com" }
  s.source   = { :git => "https://github.com/conekta/conekta-elements-react-native.git", :tag => s.version }

  s.ios.deployment_target = "14.0"
  s.swift_version = "5.9"

  s.dependency "React-Core"

  # Downloads the xcframework from a private GitHub release.
  # Requires a GitHub personal access token with `repo` scope:
  #   export GITHUB_TOKEN=<your_token>
  #   pod install
  s.prepare_command = <<-CMD
    if [ -z "$GITHUB_TOKEN" ]; then
      echo "error: GITHUB_TOKEN is not set. Export a GitHub token with repo scope before running pod install."
      exit 1
    fi
    curl -L \
         -H "Authorization: Bearer $GITHUB_TOKEN" \
         -H "Accept: application/octet-stream" \
         "https://github.com/conekta/conekta-elements/releases/download/latest/composeKit.xcframework.zip" \
         -o composeKit.xcframework.zip
    unzip -o composeKit.xcframework.zip
    rm     composeKit.xcframework.zip
  CMD

  s.vendored_frameworks = "composeKit.xcframework"
  s.source_files        = "ios/**/*.{swift,m,h}"
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.9" }
end
