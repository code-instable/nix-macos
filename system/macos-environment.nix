{
  lib,
  config,
  ...
}: let
  macbook_air_m1_network_services = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];

  # Helper to create DNS check for each interface
  dns_check_all_interfaces_script = lib.concatStrings (map (interface:
    /*
    zsh
    */
    ''
      printf "\n\nchecking DNS for \033[1;32m${interface}\033[0m..." >&2
      if networksetup -listallnetworkservices | grep -q "${interface}"; then
        printf "current DNS for ${interface} is \n%s" "$(networksetup -getdnsservers '${interface}')" >&2
      fi
    '')
  macbook_air_m1_network_services);

  dns_script =
    /*
    zsh
    */
    ''
      printf "\n\033[1;33m⟩ Flushing DNS Cache: \n\033[0m" >&2

      echo "flushing cache..." >&2
      sudo dscacheutil -flushcache && printf "\n\033[1;32m✔ succeeded\n\033[0m" >&2 || printf "\n\033[1;31m✘ failed\n\033[0m" >&2
      echo "killing mDNSResponder"
      sudo killall -HUP mDNSResponder && printf "\n\033[1;32m✔ succeeded\n\033[0m" >&2 || printf "\n\033[1;31m✘ failed\n\033[0m" >&2

      printf "\n\033[1;33m⟩ Checking DNS values: \n\033[0m" >&2
      ${dns_check_all_interfaces_script}
    '';

  one_dot_one_porn_block = [
    # 1.1.1.1 Family (porn block)
    "1.1.1.3"
    "1.0.0.3"
    "2606:4700:4700::1113"
    "2606:4700:4700::1003"
  ];

  one_dot_one = [
    # 1.1.1.1 Family (porn block)
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];
in {
  # System Shell Aliases
  environment.shellAliases = {
    exa =
      /*
      zsh
      */
      ''eza --icons'';
    rebuild =
      /*
      zsh
      */
      ''darwin-rebuild switch --flake ${config.users.users.instable.home}/.config/nix --cores 7 --verbose -j 7'';
    restart =
      /*
      zsh
      */
      ''source ${config.users.users.instable.home}/.zshrc'';
    yz =
      /*
      zsh
      */
      ''yazi'';
    marta =
      /*
      # zsh
      */
      ''open -a Marta'';
    m =
      /*
      # zsh
      */
      ''micromamba'';
    zen =
      /*
      # zsh
      */
      ''open -a "Zen Browser"'';
    pdf =
      /*
      # zsh
      */
      ''zathura'';
    homerebuild =
      /*
      # zsh
      */
      ''home-manager switch -f ${config.users.users.instable.home}/.config/nix/home.nix'';
    aicode =
      /*
      # zsh
      */
      ''aichat --model "github:codestral-2501" --role "%code%"'';
    deepseek =
      /*
      # zsh
      */
      ''aichat --model "github:deepseek-r1"'';
    aishell =
      /*
      # zsh
      */
      ''aichat --model "github:codestral-2501" --role "%shell%"'';
    ai =
      /*
      # zsh
      */
      ''aichat --model "github:mistral-nemo"'';
  };

  # Settings
  # needs `system.primaryUser` — to apply user-level settings from root (darwin-rebuild)
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      static-only = true;
      # persistent-apps = [
      # ];
      persistent-others = [];
    };
    WindowManager = {
      GloballyEnabled = false;
      HideDesktop = true;
      StandardHideDesktopIcons = true;
      StandardHideWidgets = true;
      EnableStandardClickToShowDesktop = false;
      AppWindowGroupingBehavior = true; # false means "One at a time" true means "All at once"
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  };
  system.startup.chime = false;

  # Networking
  networking.dns = one_dot_one;

  networking.knownNetworkServices = macbook_air_m1_network_services;

  system.activationScripts.flushDNS.text = dns_script;

  #  `sudo systemsetup -listtimezones | fzf`
  time.timeZone = "Europe/Brussels";

  # https://mynixos.com/nix-darwin/option/system.defaults.CustomSystemPreferences
  system.defaults.CustomSystemPreferences = {};

  # https://gist.github.com/j8/8ef9b6e39449cbe2069a
  # ⓘ animate opening and closing of windows and popovers
  system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
  # ⓘ speed of the Mission Control animations
  system.defaults.dock.expose-animation-duration = 0.0;
  # ⓘ speed of window resizing
  system.defaults.NSGlobalDomain.NSWindowResizeTime = 0.001;

  # enable smooth scrolling
  system.defaults.NSGlobalDomain.NSScrollAnimationEnabled = true;
  # ⓘ autohide the menu bar
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  # ⓘ use 24-hour
  system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;

  # ⓘ swiping left or right with two fingers to navigate backward or forward
  system.defaults.NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
  system.defaults.NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;

  # ⓘ press-and-hold feature
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  # ⓘ show all file extensions in Finder
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;

  # ⓘ how long you must hold down the key before it starts repeating
  # system.defaults.NSGlobalDomain.InitialKeyRepeat = ;
  # ⓘ how fast it repeats once it starts
  # system.defaults.NSGlobalDomain.KeyRepeat = ;

  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = true;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  # ⓘ automatic termination of inactive apps
  system.defaults.NSGlobalDomain.NSDisableAutomaticTermination = false;

  system.defaults.screencapture.target = "clipboard";
  system.defaults.screencapture.show-thumbnail = true;
  system.defaults.screencapture.disable-shadow = true;
  # behavior of fn/🌐 key
  system.defaults.hitoolbox.AppleFnUsageType = "Do Nothing";
  # ⓘ quarantine for downloaded applications
  system.defaults.LaunchServices.LSQuarantine = false;

  /*
  environment.systemPath = [
    "/Users/instable/micromamba/envs/latest/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/Users/instable/micromamba/condabin"
    "/Users/instable/.data/zinit/polaris/bin"
    "/Users/instable/.nix-profile/bin"
    "/etc/profiles/per-user/instable/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "/Users/instable/.modular/bin"
    "/Users/instable/.local/bin"
    "/Users/instable/.modular/bin"
    "/Users/instable/.local/bin"
  ];
  */
}
