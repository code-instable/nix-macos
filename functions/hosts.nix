{config, pkgs, lib, ...}:
let
  # note : relative to THIS FILE, not the system flake's location
  hosts-default = builtins.readFile ../data/hosts-default;
  hosts-porn = builtins.readFile ../data/hosts-porn;

  # sha256 : c7dd0e2ed261ce76d76f852596c5b54026b9a894fa481381ffd399b556c0e2a
  original_hosts_file = /* zsh */
''
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	localhost
255.255.255.255	broadcasthost
::1             localhost
'';
in
{
  # error: Unexpected files in /etc, aborting activation
  # The following files have unrecognized content and would be overwritten:
  # /etc/hosts
  # Please check there is nothing critical in these files, rename them by adding .before-nix-darwin to the end, and then try again.
  # `sudo mv /etc/hosts /etc/hosts.before-nix-darwin`

  environment.etc."hosts".text = "${hosts-default}" + "\n" + "${hosts-porn}";
}
