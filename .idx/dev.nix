{ pkgs, ... }: {
  channel = "stable-25.05";
  packages = [
    pkgs.nodejs_20
    pkgs.jdk17_headless
    pkgs.gradle
    pkgs.android-tools
    pkgs.watchman
    pkgs.curl # Add curl for health checking Metro
  ];
  idx = {
    extensions = [
      "msjsdiag.vscode-react-native"
      "dbaeumer.vscode-eslint"
      "esbenp.prettier-vscode"
    ];
    workspace = {
      onCreate = {
        install = ''
                    # Todo se ejecuta desde example/ (app React Native)
                    cd example &&
                    npm install --prefer-offline --no-audit --no-progress

                    # Bootstrap native folders when repository only has JS example files.
                    # `run-android` requires example/android/settings.gradle and example/android/app.
                    if [ ! -f android/settings.gradle ] || [ ! -d android/app ]; then
                      echo "Bootstrapping React Native native folders for example/..."
                      TMP_RN_DIR="$(mktemp -d)"
                      npx --yes react-native@0.73.6 init TempExample --skip-install --directory "$TMP_RN_DIR"
                      rm -rf android ios
                      mv "$TMP_RN_DIR/android" ./android
                      mv "$TMP_RN_DIR/ios" ./ios
                      rm -rf "$TMP_RN_DIR"
                    fi

                    # Create local Android SDK directory in home folder
                    mkdir -p $HOME/.android-sdk-local
                    export ANDROID_SDK_ROOT=$HOME/.android-sdk-local
                    export ANDROID_HOME=$ANDROID_SDK_ROOT
                    export GRADLE_USER_HOME=$PWD/.gradle-home
                    mkdir -p "$GRADLE_USER_HOME"

                    rm -rf ~/.gradle/caches/

                    # Accept Android SDK licenses
                    mkdir -p $ANDROID_SDK_ROOT/licenses
                    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > $ANDROID_SDK_ROOT/licenses/android-sdk-license
                    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> $ANDROID_SDK_ROOT/licenses/android-sdk-license
                    echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_SDK_ROOT/licenses/android-sdk-preview-license

                    # Add more memory to the JVM (cwd es example/, android/ está ahí)
                    sed -i 's/org.gradle.jvmargs=-Xmx2048m -XX:MaxMetaspaceSize=512m/org.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=512m/' android/gradle.properties

                     # Print success message in green
                     echo -e "\n\033[1;32m╭──────────────────────────────────────────────────────────╮\033[0m"
                     echo -e "\033[1;32m│ ✓ Dependencies installed successfully!                   │\033[0m"
                     echo -e "\033[1;32m│                                                          │\033[0m"
                     echo -e "\033[1;32m│ Preview initialization in progress...                    │\033[0m"
                     echo -e "\033[1;32m│ To view logs: Open Output panel and select IDX           │\033[0m"
                     echo -e "\033[1;32m│ (View > Output > IDX)                                    │\033[0m"
                     echo -e "\033[1;32m╰──────────────────────────────────────────────────────────╯\033[0m\n"
        '';
      };
    };
    previews = {
      enable = true;
      previews = {
        android = {
          command = [
            "sh"
            "-c"
            ''
              # Ejecutar todo desde example/ (app React Native)
              cd example || exit 1

              if [ ! -f android/settings.gradle ] || [ ! -d android/app ]; then
                echo "Android project not initialized in example/ (missing android/settings.gradle or android/app)."
                echo "Rebuild the IDX workspace so onCreate can bootstrap native folders."
                exit 1
              fi

              export RCT_METRO_PORT=$PORT
              export GRADLE_USER_HOME=$PWD/.gradle-home
              mkdir -p "$GRADLE_USER_HOME"

              # Avoid daemon protocol/cache conflicts between different Java/Gradle environments.
              ./android/gradlew --stop >/dev/null 2>&1 || true

              watchman watch $PWD

              npm start &
              METRO_PID=$!

              until curl -s http://localhost:$PORT/status > /dev/null; do
                sleep 1
              done

              # --no-packager: Metro ya está corriendo arriba; evita "no terminal app was specified"
              npm run android -- --no-packager --no-daemon
              wait $METRO_PID
            ''
          ];
          manager = "web";
        };
      };
    };
  };
}
