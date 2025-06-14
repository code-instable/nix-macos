{ config, pkgs, ... }:

let
  homeDir = config.users.instable.config;
in
pkgs.writeTextFile {
  name = "environment-plist";
  destination = "${homeDir}/Library/LaunchAgents/environment.plist";
  text = /* xml */
  ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>my.startup.shell_agnostic.environment</string>
      <key>ProgramArguments</key>
      <array>
        <string>sh</string>
        <string>-c</string>
        <string>launchctl setenv XDG_CONFIG_HOME ~/.config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  '';
}
