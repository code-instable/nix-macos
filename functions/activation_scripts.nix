# TODO
{pkgs, lib, config, ...}:
let

in
{
  imports = [
    ./pkg-config.nix
  ];

  system.activationScripts.postActivation.text = lib.concatStringsSep "\n" [
    
  ];
}
