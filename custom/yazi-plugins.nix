{
  description = "My system configuration with Yazi setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.yazi-setup = pkgs.stdenv.mkDerivation {
          name = "yazi-setup";
          buildInputs = [ pkgs.yazi pkgs.yarn ];

          buildCommand = /* zsh */
          ''
            # ensure the plugins directory exists, otherwise create it (else it will error)
            mkdir -p "$HOME/.config/yazi/plugins"

            # Run the ya pack command
            echo "installing yazi plugin : mactag..." >&2
            ya pack -a yazi-rs/plugins:mactag

            echo "configuring yazi plugin : mactag..." >&2
            mkdir -p $HOME/.config/yazi

            if [ ! -f $HOME/.config/yazi/init.lua ]; then
              cat <<EOF > $HOME/.config/yazi/init.lua
require("mactag"):setup {
  keys = {
    r = "Red",
    o = "Orange",
    y = "Yellow",
    g = "Green",
    b = "Blue",
    p = "Purple",
  },
  colors = {
    Red    = "#ee7b70",
    Orange = "#f5bd5c",
    Yellow = "#fbe764",
    Green  = "#91fc87",
    Blue   = "#5fa3f8",
    Purple = "#cb88f8",
  },
}
EOF
            fi

            if [ ! -f $HOME/.config/yazi/yazi.toml ]; then
              cat <<EOF > $HOME/.config/yazi/yazi.toml
[[plugin.prepend_fetchers]]
id   = "mactag"
name = "*"
run  = "mactag"

[[plugin.prepend_fetchers]]
id   = "mactag"
name = "*/"
run  = "mactag"
EOF
            fi

            if [ ! -f $HOME/.config/yazi/keymap.toml ]; then
              cat <<EOF > $HOME/.config/yazi/keymap.toml
[[manager.prepend_keymap]]
on   = [ "b", "a" ]
run  = 'plugin mactag --args="add"'
desc = "Tag selected files"

[[manager.prepend_keymap]]
on   = [ "b", "r" ]
run  = 'plugin mactag --args="remove"'
desc = "Untag selected files"
EOF
            fi
          '';
        };

        defaultPackage = self.packages.${system}.yazi-setup;
      });
}
