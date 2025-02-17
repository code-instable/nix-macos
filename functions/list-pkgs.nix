{config, pkgs, lib, ...}:
{
  #  `bat /etc/current-system-packages`
  # > view all installed packages
  # this creates file /etc/current-system-packages with list of all packages with their versions 
  # 🌐 https://www.reddit.com/r/NixOS/comments/fsummx/how_to_list_all_installed_packages_on_nixos/
  environment.etc."current-system-packages".text =
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
}