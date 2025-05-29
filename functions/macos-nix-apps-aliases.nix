# activation.nix
{ pkgs, config, ... }: {

  # among the list of script (names) that can be executed :
  #   - applications
  # executed in the midde of all scripts as a special script
  # https://github.com/LnL7/nix-darwin/blob/master/modules/system/activation-scripts.nix#L86
  # ⓘ append packages installed via nixpkgs to /Applications/Nix Apps, as symlinks
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };

    # for the user `instable`
    currentUser = config.users.users.instable.name;
    userHome = config.users.users.${currentUser}.home;

    obs_config_symlink = {
      # the config is located in $HOME/Library/Application Support/obs-studio
      config_location =
        "${userHome}/Library/Application Support/obs-studio";
      # points to $HOME/.config/obs-studio
      symlink_location = "${userHome}/.config/obs-studio";
    };
  in pkgs.lib.mkForce /* zsh */
  ''
    printf "\n\033[1;33m⟩ Post-build symlink scripts: \n\033[0m" >&2
    # $⟩ 1) Set up applications.
    # $ ===============================================
    printf "\t\033[1;32m⟩ Nix Packages recognition in spotlight/raycast: \n\n\033[0m" >&2

    echo "setting up /Applications..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read -r src; do
      app_name=$(basename "$src")
      echo "copying $src" >&2
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    done
    # $ ===============================================

    printf "\n\t\033[1;32m⟩ ~/.config/<app> symlinks: \n\033[0m" >&2
    # $⟩ 2) setup obs-studio config symlink to .config
    # $ ===============================================
    printf "\t\t\033[1;34m⟩ obs-studio: \n\n\033[0m" >&2

    # ? if the obs-studio config exists in the user's Library/Application Support
    if [[ -d "${obs_config_symlink.config_location}" ]]; then
      # ? and the symlink does not exist in the user's .config
      if [[ ! -d "${obs_config_symlink.symlink_location}" ]] && [[ ! -L "${obs_config_symlink.symlink_location}" ]]; then
        # ? create the symlink
        echo "creating symlink for obs-studio in .config..." >&2
        ln -s "${obs_config_symlink.config_location}" "${obs_config_symlink.symlink_location}"
        # ? and check if the symlink was created
        if [[ -L "${obs_config_symlink.symlink_location}" ]]; then
          echo "symlink created for obs-studio in .config" >&2
        else
          echo "failed to create symlink for obs-studio in .config" >&2
        fi
        # ? =====================================
      elif [[ -L "${obs_config_symlink.symlink_location}" ]]; then
        echo "${obs_config_symlink.symlink_location}" symlink already exists. Skipping...
      fi
    fi

    printf "\n\033[1;33m⟩ [done] : Post-build symlink scripts \n\n\033[0m" >&2
    # $ ===============================================
  '';
}
