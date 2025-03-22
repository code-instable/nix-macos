{pkgs, config, ...}:
let
  # ⓘ cli apps and libraries
  brew = [
    "openjdk"
    "openjdk@11"
    "node@23"
    "tag"
    # "bitwarden-cli" # | rbw is a better client
    {name="numi-cli";}
    # brew tap ohueter/tap
    # change keyboard layout depending on current keyboard https://github.com/ohueter/autokbisw
    {
      name="autokbisw";
      # Service `autokbisw` already started, use `brew services restart autokbisw` to restart.
      # restart_service = "changed";

      # then run : 'brew services start autokbisw'
      # start_service = true;
    }    
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
    "ghostty"
    "skim"
    "github" # github desktop
    "keyboardcleantool"
    "shottr"
    "wolfram-engine"
    "firefox"
    "vlc"
    "typora"
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
    enable = true;

    taps = [
      "homebrew/bundle"
      "homebrew/bundle"
      "homebrew/services"
      "nikolaeu/numi"
      "ohueter/tap"
      # no longer necessary
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
