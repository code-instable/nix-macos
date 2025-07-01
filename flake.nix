{
  description = "Macbook Air M1 - dev";

  # ⓘ check if all sources are properly added :
  # `nix flake metadata --json . | jq  ".locks.nodes.root.inputs[]" | sed 's/"//g' | fzf`
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      # ⓘ `follows` attribute tells Nix that the nixpkgs input within nix-darwin should follow or track the same version as the top-level nixpkgs input defined above | any updates or changes to the main nixpkgs input will automatically be reflected in nix-darwin's nixpkgs, ensuring that they remain in sync without requiring manual adjustments
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ⓘ patches for common problems using nix on macos such as app discovery (home-manager, system-wide), spotlight, ...
    mac-app-util.url = "github:hraban/mac-app-util";
    # ⓘ manage homebrew apps using nix
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # □ Add the input for the simple-completion-language-server flake
    #   □ check flake structure
    #      `nix flake show github:estin/simple-completion-language-server/main`
    #       github:estin/simple-completion-language-server/
    #       ├───defaultPackage
    #       │   ├───aarch64-darwin: package 'simple-completion-language-server-0.1.0'
    #           => (inputs.simple-completion-language-server).defaultPackage.${system}
    simple-completion-language-server = {
      url = "github:estin/simple-completion-language-server/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    yt-x.url = "github:Benexl/yt-x";

    #  `nix flake show "github:helix-editor/helix/master"`
    # github:helix-editor/helix/
    # └───packages
    #     ├───aarch64-darwin
    #     │   ├───default: package 'helix-term'
    #     │   └───helix: package 'helix-term'
    #     => packages.${system}.helix
    # 
    # ⓘ making sure not to rebuild helix everyday : get the current master branch's revision
    # get the latest commit from the master branch: (yq ommits quotes ", jq display them)
    #  `printf '%s' $(nix flake metadata --json "github:helix-editor/helix/master" | yq '.url')`
    helix-source = {
      #  `printf "url = %s;" $(nix flake metadata --json "github:helix-editor/helix/master" | jq '.url')`
      url = "github:helix-editor/helix/c3c4895179d4bc5a00e22fdf129d41c1af96226a?narHash=sha256-pbF4oz%2BHZE/rXsm9YOOA9aV/QnwTvc0zHDTpkaHpYK4%3D";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # `printf '%s' $(nix flake metadata --json "github:mfontanini/presenterm/master" | yq '.url')`
    # `nix flake show 'github:mfontanini/presenterm/master'`
    # └───packages
    #     ├───aarch64-darwin
    #     │   └───default: package 'presenterm-0.11.0'
    presenterm.url = "github:mfontanini/presenterm";

    # `nix flake show "github:sioodmy/todo"`
    # github:sioodmy/todo
    # ├───apps
    # │   ├───aarch64-darwin
    # │   │   └───todo: app
    # ├───defaultApp
    # │   ├───aarch64-darwin: app
    # ├───defaultPackage
    # │   ├───aarch64-darwin: package 'todo-bin-0.1.0'
    # => (inputs.todo).defaultPackage.${system}
    todo.url = "github:sioodmy/todo";

    # => (inputs.latex2utf8).packages.${system}.lutf
    latex2utf8.url = "github:code-instable/latex2utf8";

    zellij-plugin-zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser-unofficial = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    # ══════════════════════════════════════╗
    #  PINNINGS : package specific version  ║
    #               management              ║
    # ══════════════════════════════════════╝

    # ——————————————————————————————————————————————————————————————————————————————— #
    # when dependency error introduced on nix update of nixpkgs-unstable              #
    # look for the package which is probelmatic in                                    #
    # https://github.com/NixOS/nixpkgs/commits/nixpkgs-unstable/                      #
    # the use the hash of the commit before                                           #
    # ——————————————————————————————————————————————————————————————————————————————— #
    # format of url :                                                                 #
    # `github:NixOS/nixpkgs/[commit-hash]`                                            #
    # note that there is NO `nixpkgs-unstable`                                        #
    # ——————————————————————————————————————————————————————————————————————————————— #

    # ⟩ YYYY/MM/DD : <software>
    # ——————————————————————————————————————————————————————————————————————————————— #
    # https://hydra.nixos.org/job/nixpkgs/trunk/<software>.aarch64-darwin/all         #
    #                                                                                 #
    #  ❌ : https://hydra.nixos.org/build/<#> (the day I encountered the problem)     #
    #  ✅ : https://hydra.nixos.org/build/<#> (1 day afer)                            #
    #                                                                                 #
    #  ✅  Succeeded                                                                  #
    #          ▶ <#> <Finished at> <Package/release name> <System>                    #
    #  ❌  Failed                                                                     #
    #          ▶ <#> <Finished at> <Package/release name> <System>                    #
    # ——————————————————————————————————————————————————————————————————————————————— #
    # https://hydra.nixos.org/build/<#-hydra_build_number>#tabs-buildinputs           #
    # ▶ then copy `Revision`                                                          #
    # ——————————————————————————————————————————————————————————————————————————————— #
    # nixpkgs-<pinned_package>.url = "github:NixOS/nixpkgs/<revision";
    # nixpkgs-spotify.url = "github:NixOS/nixpkgs/afa43e1383d4d604ed3575bf95b3905354a9a51b";
    nixpkgs-R-4_5_0.url = "github:NixOS/nixpkgs/c32298d71b5dc1fe4405e997aabb3908c0ca639d";
  };

  outputs = { self,

    # default input repositories
    nix-darwin, nix-homebrew, nixpkgs, home-manager, mac-app-util,

    # github flakes input
    simple-completion-language-server, yt-x, helix-source, todo, presenterm
    , latex2utf8, zellij-plugin-zjstatus, zen-browser-unofficial,

    # 🚧 ===      pinning     === 🚧
    # nixpkgs-pkg,
    # nixpkgs-spotify,
    nixpkgs-R-4_5_0,
    # 🚧 === ---------------- === 🚧
    ...
    }@inputs: # make them available as inputs.simple-completion-language-server, inputs.[***], ...
    let
      # get system automatically
      # useful for source.defaultPackage.${system}
      system = if builtins ? currentSystem then
        builtins.currentSystem
      else
        "aarch64-darwin";

      configuration = { pkgs, config, ... }: {
        # Takes the flake inputs (from @inputs)
        # Makes them available to all modules as `inputs`
        # Allows accessing flake inputs in any module file
        _module.args.inputs = inputs; # → used for `system/system-packages.nix`, especially for flakes from other githubs than nixpkgs

        # override the packages for which we need a downgrade
        # https://nixos.wiki/wiki/Overlays
        nixpkgs.overlays = [
          # Overlay: Use `self` and `super` to express
          # the inheritance relationship
          (self: super:
          {
            #                 command                
            # ⓘ use helix from the "master" branch from official github repo instead of unstsable nixpkgs version while stille referring to it as `pkgs.helix`
            helix = helix-source.packages.${system}.helix;
            #     -------------------------------   
            # ⓘ FREE PACKAGES FROM PINNED NIXPKGS ⓘ
            # pkg = nixpkgs-pkg.legacyPackages.${system}.pkg;
            # ⓘ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ⓘ
            # quarto = nixpkgs-quarto.legacyPackages.${system}.quarto;

            # R 4.5.0 with radian
            R = nixpkgs-R-4_5_0.legacyPackages.${system}.R;
            rWrapper = nixpkgs-R-4_5_0.legacyPackages.${system}.rWrapper;
            rstudioServerWrapper = nixpkgs-R-4_5_0.legacyPackages.${system}.rstudioServerWrapper;
            radianWrapper = nixpkgs-R-4_5_0.legacyPackages.${system}.radianWrapper;
            radian = nixpkgs-R-4_5_0.legacyPackages.${system}.radian;
            # ⓘ UNFREE PACKAGES FROM PINNED NIXPKGS ⓘ
            # When using a pinned/older nixpkgs version for unfree packages, you need to:
            # 1. Import the specific nixpkgs with explicit unfree configuration
            # 2. The allowUnfreePredicate must be applied to the pinned nixpkgs instance
            # This is because overlays don't inherit the main nixpkgs unfree settings, which requires more verbose syntax
            /* ```nix
            unfree_pkg = (import nixpkgs-pkg {
              inherit system;
              config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
                "unfree_pkg"
              ];
            }).unfree_pkg;
            ``` */
            # ⓘ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ⓘ
            # spotify = (import nixpkgs-spotify {
            #   inherit system;
            #   config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
            #     "spotify"
            #   ];
            # }).spotify;
          })
          # ⓘ Register Github Flakes as nixpkgs packages (pkgs.non_nixpkgs_pkg)
          # https://github.com/dj95/zjstatus/wiki/1-‐-Installation#nix-flakes
          (final: prev: {
            zjstatus = zellij-plugin-zjstatus.packages.${prev.system}.default;
          })
        ];

        imports = [
          # packages
          ./system/system-packages.nix
          ./system/brew-cask-mas.nix
          ./functions/macos-nix-apps-aliases.nix # linking script
          # fonts
          ./system/fonts.nix
          # system settings
          ./system/macos-environment.nix
          ./functions/java_ver_env_var.nix
          # scripts to run after build
          ./functions/activation_scripts.nix
          # etc files
          ./functions/list-pkgs.nix
          # ./functions/hosts.nix
        ];

        nix = {
          # ⓘ ensures that the Nix daemon service is active, enabling secure and efficient multi-user package management on your system
          # error:
          # Failed assertions:
          # - The option definition `services.nix-daemon.enable' in `<unknown-file>' no longer has any effect; please remove it.
          # nix-darwin now manages nix-daemon unconditionally when
          # `nix.enable` is on.
          # services.nix-daemon.enable = true;
          enable = true;
          gc.automatic = true;
          optimise.automatic = true;
          settings = {
            # ⓘ This line allows you to use the `nix` command with flakes.
            experimental-features = [ "nix-command" "flakes" ];
          };
        };
        # ⓘ This line ensures that system.configurationRevision is set to the most accurate revision of your configuration:
        #   1. Uses `self.rev` if the flake is at a clean Git commit.
        #   2. Falls back to `self.dirtyRev` if there are uncommitted changes.
        #   3. Defaults to `null` if no revision information is available.
        system.configurationRevision = self.rev or self.dirtyRev or null;
        
        # ⓘ M1 processor binaries
        nixpkgs.hostPlatform = "aarch64-darwin";

        # ⚠️ Used for backwards compatibility, please read the changelog before changing.
        system.stateVersion = 5;

        # ⓘ this makes sudo also work with Touch ID
        security.pam.services.sudo_local.touchIdAuth = true;

        # ~ Users
        system.primaryUser = "instable";
        # &⟩ instable
        # ⓘ defines the user instable
        users.users.instable = {
          home = "/Users/instable";
          name = "instable";
        };
        environment.variables = {
          XDG_CONFIG_HOME = "/Users/instable/.config";
          XDG_CACHE_HOME = "/Users/instable/.cache";
          XDG_DATA_HOME = "/Users/instable/.data";
        };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#instables-MacBook-Air
      # $ darwin-rebuild switch --flake ~/.config/nix
      darwinConfigurations."instables-MacBook-Air" =
        nix-darwin.lib.darwinSystem {
          modules = [
            # system configuration
            configuration
            # homebrew configuration
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                # ⓘ brew needs Rosetta as built for x86_64
                #   softwareupdate --install-rosetta
                enableRosetta = true;
                user = "instable";
              };
            }
            # home-manager configuration
            home-manager.darwinModules.home-manager
            {
              nixpkgs.overlays = [ inputs.nixpkgs-firefox-darwin.overlay ];
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true;
              home-manager.sharedModules =
                [ mac-app-util.homeManagerModules.default ];
              # user specific
              home-manager.users.instable = import ./home/instable.nix;
            }
          ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."instables-MacBook-Air".pkgs;
    };
}
