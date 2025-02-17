{pkgs, config, ...}:
let
  # ⓘ cli apps and libraries
  brew = [
    "openjdk"
    "openjdk@11"
    "node@23"
    "tag"
    # "bitwarden-cli" # | rbw is a better client
    "nikolaeu/numi/numi-cli"
    "ohueter/tap/autokbisw"
    # then run : 'brew services start autokbisw'
  ];
  # ⓘ gui apps
  cask = [
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
