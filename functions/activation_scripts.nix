# system.activationScripts.{pre/post}(User)Activation
# cf : https://github.com/LnL7/nix-darwin/blob/master/modules/system/activation-scripts.nix#L148-L155
{pkgs, lib, config, ...}:
let
  # update_vscode_extensions-path = ../scripts/update_vscode_extensions.nu;
  # 🚧 does not work because needs : `${pkgs.vscode}/bin/code` and not `code`

  update_vscode_extensions-script-nu = /* nu */
  ''
  ['base' 'Default' 'document' 'dynamic' 'static' 'web-dev']
  | each {
    |profile|
    ${pkgs.vscode}/bin/code --user-data-dir ${config.users.users.instable.home}/.vscode --update-extensions --profile \$profile
  }
  '';

  update_vscode_extensions-script = /* zsh */
  ''
    printf "\n\033[1;33m⟩ updating vscode extensions: \n\033[0m" >&2
    ${pkgs.nushell}/bin/nu -c "${update_vscode_extensions-script-nu}"
  '';
  
  # ⓘ note: _script in the name allows for syntax highlight
  xdg_open_symlink_script = /* zsh */
  ''
    printf "\n\033[1;33m⟩ symlinking open -> xdg-open: \n\033[0m" >&2
    printf "creating 'xdg-open' (linux) symlink for 'open' (macos) command in '/usr/local/bin' directory, prevents zathura from crashing on link open" >&2
    ln -s "/usr/bin/open" "/usr/local/bin/xdg-open" && printf "\n\033[1;32m✔ created symlink successfully.\n\033[0m" >&2 || printf "\n\033[1;31m✘ symlink creation failed.\n\033[0m" >&2
  '';

  dorion_is_damaged-script = /* zsh */
  ''
  sudo xattr -rd com.apple.quarantine /Applications/Dorion.app
  '';
in
{
  imports = [
    ./pkg-config.nix
  ];
  # scripts defined within this file
  system.activationScripts = {
      xdg_open_symlink.text = xdg_open_symlink_script;
      update_vscode_extensions.text = update_vscode_extensions-script;
      dorion_is_damaged.text = dorion_is_damaged-script;
  };
  

  # very first script executed
  system.activationScripts.preActivation.text = lib.concatStringsSep "\n" [
    
  ];

  # very last script executed
  system.activationScripts.postActivation.text = let
    post_activation_scripts = with config.system.activationScripts; [
      # pkg_config-path.text
      pkgConfigPath.text
      xdg_open_symlink.text
      # system/macos-environment.nix
      flushDNS.text
      # update_vscode_extensions.text
      dorion_is_damaged.text
    ];
  in lib.concatStringsSep "\n" post_activation_scripts;
}
