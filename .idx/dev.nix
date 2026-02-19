{ pkgs, ... }: {
  channel = "stable-25.05";

  packages = [ pkgs.nodejs_18 ];

  idx = {
    extensions = [
      "msjsdiag.vscode-react-native"
      "dbaeumer.vscode-eslint"
    ];

    workspace = {
      onCreate = {
        install = "npm install --prefer-offline && cd example && npm install --prefer-offline";
      };

      onStart = {
        start-metro = ''
          npm install --prefer-offline && \
          cd example && \
          npm install --prefer-offline && \
          npx react-native start --port 8081
        '';
      };
    };

    previews = {
      enable = true;
      previews = {
        android = {
          command = [
            "bash" "-c"
            ''
              adb -s emulator-5554 wait-for-device && \
              adb -s emulator-5554 reverse tcp:8081 tcp:8081 && \
              cd example && \
              npx react-native run-android --port 8081
            ''
          ];
          manager = "android";
        };
      };
    };
  };
}
