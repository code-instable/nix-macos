{pkgs, config, ...}:
let
  # ⓘ cli apps and libraries
  brew = [
    {name = "openjdk";}
    {name = "openjdk@11";}
    {name = "node@23";}
    {name = "tag";}
    {name = "numi-cli";}
    # brew tap ohueter/tap
    # change keyboard layout depending on current keyboard https://github.com/ohueter/autokbisw
    # troubleshoot
    # Preferences > Security & Privacy > Privacy > Input Monitoring: remove autokbisw
    # System Settings > Keyboard > Input sources > Edit: disable `Automatically switch to a document's input source`
    #  `brew services restart autokbisw ; launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.autokbisw.plist; launchctl load ~/Library/LaunchAgents/homebrew.mxcl.autokbisw.plist;`
    {
      name="autokbisw";
      # ⓘ Service `autokbisw` already started, use `brew services restart autokbisw` to restart.
      # restart_service = "changed";
      # ⓘ then run : 'brew services start autokbisw'
      start_service = true;
    }    
    # {name="fancy-cat";}
  ];
  # ⓘ gui apps
  cask = [
    # "calibre"
    "ghostty"
    "obs"
    "zed"
    "betterdisplay"
    "amethyst"
    "marta"
    "kitty"          
    "skim"
    "github" # github desktop
    "keyboardcleantool"
    "shottr"
    "wolfram-engine"
    "vlc"
    "typora"
    "karabiner-elements"
  ];
  # ⓘ App Store apps
  mas = {
      "Goodnotes" = 1444383602;    # note taking / viewing
      "XCode" = 497799835;         # required for ohueter/tap/autokbisw
      "TestFlight" = 899247664;    # beta tester
  };
in
{
  homebrew = {
    enable = true; # needs `system.primaryUser` — to apply user-level settings from root (darwin-rebuild)

    taps = [
      "nikolaeu/numi"
      "ohueter/tap"
      # no longer necessary
      # "homebrew/bundle"
      # "homebrew/services"
      # "homebrew/core"
      # "homebrew/cask"
    ];

    # ⓘ brew casks (gui apps)
    brews = brew;

    casks = cask;
    # ⓘ App Store apps
    #   mas search Goodnotes 
    masApps = mas;
    # ⓘ remove non used packages (apps, dependencies)
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
