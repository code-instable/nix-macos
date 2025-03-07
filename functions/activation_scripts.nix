# system.activationScripts.{pre/post}(User)Activation
# cf : https://github.com/LnL7/nix-darwin/blob/master/modules/system/activation-scripts.nix#L148-L155
{pkgs, lib, config, ...}:
let
  move_base_hosts = ''
    # move hosts so that it can be replaced by anti-porn hosts without error
    [[ $(wc -l < /etc/hosts | tr -d "\n") == "9" ]] && sudo mv /etc/hosts /etc/hosts.bkp || echo "not base hosts file"
    '';
in
{
  imports = [
    ./pkg-config.nix
  ];

  # very first script executed
  system.activationScripts.preActivation.text = lib.concatStringsSep "\n" [
    
  ];

  # very last script executed
  system.activationScripts.postActivation.text = lib.concatStringsSep "\n" [
    config.system.activationScripts.pkg_config-path.text
  ];
}
