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
            "cd example && npx react-native run-android --port 8081"
          ];
          manager = "android";
        };
      };
    };

    workspace = {
      onCreate = {
        install-deps = {
          command = "npm install && cd example && npm install";
          runInBackground = true;
        };
      };

      onStart = {
        setup-adb = {
          command = "adb -s localhost:5554 wait-for-device && adb -s localhost:5554 reverse tcp:8081 tcp:8081";
          runInBackground = false;
        };
        start-metro = {
          command = "cd example && npx react-native start --port 8081";
          runInBackground = true;
        };
      };
    };
  };
}
