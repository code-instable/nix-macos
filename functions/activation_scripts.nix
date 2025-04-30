# system.activationScripts.{pre/post}(User)Activation
# cf : https://github.com/LnL7/nix-darwin/blob/master/modules/system/activation-scripts.nix#L148-L155
{pkgs, lib, config, ...}:
let
  # ⓘ note: _script in the name allows for syntax highlight
  xdg_open_symlink_script = ''
    printf "\n\033[1;33m⟩ symlinking open -> xdg-open: \n\033[0m" >&2
    printf "creating 'xdg-open' (linux) symlink for 'open' (macos) command in '/usr/local/bin' directory, prevents zathura from crashing on link open" >&2
    ln -s "/usr/bin/open" "/usr/local/bin/xdg-open" && printf "\n\033[1;32m✔ created symlink successfully.\n\033[0m" >&2 || printf "\n\033[1;31m✘ symlink creation failed.\n\033[0m" >&2
  '';
in
{
  imports = [
    ./pkg-config.nix
  ];
  # scripts defined within this file
  system.activationScripts = {
      xdg_open_symlink.text = xdg_open_symlink_script;
  };


  # very first script executed
  system.activationScripts.preActivation.text = lib.concatStringsSep "\n" [
    
  ];

  # very last script executed
  system.activationScripts.postActivation.text = lib.concatStringsSep "\n" [
    config.system.activationScripts.pkg_config-path.text
    config.system.activationScripts.xdg_open_symlink.text
    # system/macos-environment.nix
    config.system.activationScripts.flushDNS.text
  ];
}
