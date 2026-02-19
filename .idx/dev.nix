{ pkgs, ... }: {
  channel = "stable-24.05";

  packages = [
    pkgs.nodejs_18
    pkgs.jdk17
    pkgs.watchman
  ];

  idx = {
    extensions = [
      "msjsdiag.vscode-react-native"
      "dbaeumer.vscode-eslint"
    ];

    previews = {
      enable = true;
      previews = {
        android = {
          command = [
            "bash" "-c"
            ''
              cd example &&
              npm install --prefer-offline &&
              npx react-native run-android --port 8081
            ''
          ];
          manager = "android";
        };
      };
    };

    workspace = {
      onCreate = {
        default.openFiles = [ "example/App.tsx" ];
      };

      onStart = {
        start-metro =
          ''
            npm install --prefer-offline &&
            cd example &&
            npm install --prefer-offline &&
            adb -s localhost:5554 reverse tcp:8081 tcp:8081 || true &&
            npx react-native start --port 8081
          '';
      };
    };
  };
}
