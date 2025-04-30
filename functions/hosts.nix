{config, pkgs, lib, ...}:
let
  # note : relative to THIS FILE, not the system flake's location
  hosts-default = builtins.readFile ../data/hosts-default;
  hosts-porn = builtins.readFile ../data/hosts-porn;
in
{
  # error: Unexpected files in /etc, aborting activation
  # The following files have unrecognized content and would be overwritten:
  # /etc/hosts
  # Please check there is nothing critical in these files, rename them by adding .before-nix-darwin to the end, and then try again.
  # `sudo mv /etc/hosts /etc/hosts.before-nix-darwin`

  environment.etc."hosts".text = "${hosts-default}" + "\n" + "${hosts-porn}";
}
