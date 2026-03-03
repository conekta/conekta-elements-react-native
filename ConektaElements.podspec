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

  s.prepare_command = <<-CMD
    curl -L \
         "https://github.com/conekta/conekta-elements/releases/download/0.2.0-beta.2/composeKit.xcframework.zip" \
         -o composeKit.xcframework.zip
    echo "e5fc1a7030756eea3f8cc4c229c178baac9369e4c3ba3238274f03824fdb02b2  composeKit.xcframework.zip" | shasum -a 256 -c -
    unzip -o composeKit.xcframework.zip
    rm     composeKit.xcframework.zip
  CMD

  s.vendored_frameworks = "composeKit.xcframework"
  s.source_files        = "ios/**/*.{swift,m,h}"
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "5.9" }
end
