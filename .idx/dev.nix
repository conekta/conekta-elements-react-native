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
        install-deps = "npm install && cd example && npm install";
      };

      onStart = {
        setup-adb   = "adb -s localhost:5554 reverse tcp:8081 tcp:8081";
        start-metro = "cd example && npx react-native start --port 8081";
      };
    };
  };
}
