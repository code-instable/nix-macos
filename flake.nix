{
  description = "Macbook Air M1 - dev";

  inputs = {
    # ⓘ defines the repository for nixpkgs and nix-darwin
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    nix-darwin.url = "github:LnL7/nix-darwin";
    # mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    # ⓘ `follows` attribute tells Nix that the nixpkgs input within nix-darwin should follow or track the same version as the top-level nixpkgs input defined above
    # any updates or changes to the main nixpkgs input will automatically be reflected in nix-darwin's nixpkgs, ensuring that they remain in sync without requiring manual adjustments
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # □ Add the input for the simple-completion-language-server flake
    #   □ check flake structure
    #      `nix flake show github:estin/simple-completion-language-server/main`
    #       github:estin/simple-completion-language-server/
    #       ├───defaultPackage
    #       │   ├───aarch64-darwin: package 'simple-completion-language-server-0.1.0'
    #           => defaultPackage.${system}
    simple-completion-language-server = {
      url = "github:estin/simple-completion-language-server/main";
      # `follows` is the inheritance syntax within inputs.
      # Here, it ensures that sops-nix's `inputs.nixpkgs` aligns with
      # the current flake's inputs.nixpkgs,
      # avoiding inconsistencies in the dependency's nixpkgs version.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ⓘ check if properly added :
    # `nix flake metadata --json . | jq  ".locks.nodes.root.inputs[]" | sed 's/"//g' | fzf`
    yt-x.url = "github:Benexl/yt-x";

    #  `nix flake show "github:helix-editor/helix/master"`
    # github:helix-editor/helix/
    # └───packages
    #     ├───aarch64-darwin
    #     │   ├───default: package 'helix-term'
    #     │   └───helix: package 'helix-term'
    #     => packages.${system}.helix
    # helix-source.url = "github:helix-editor/helix/master";
    # ⓘ making sure not to rebuild helix everyday : get the current master branch's revision
    #  `nix flake metadata --json "github:helix-editor/helix/master" | jq '.url' | tr -d '\n' | tr -d "\""`
    helix-source.url = "github:helix-editor/helix/fbc0f956b310284d609f2c00a1f4c0da6bcac165?narHash=sha256-0YzWN%2B%2B/zu1tg7U5MC9H3C2VQo8vEEUbpaFpIpMlZB8%3D";

    # `nix flake show "github:sioodmy/todo"`
    # github:sioodmy/todo
    # ├───apps
    # │   ├───aarch64-darwin
    # │   │   └───todo: app
    # ├───defaultApp
    # │   ├───aarch64-darwin: app
    # ├───defaultPackage
    # │   ├───aarch64-darwin: package 'todo-bin-0.1.0'
    # (inputs.todo)
    # => defaultPackage.${system}
    todo.url = "github:sioodmy/todo";

    # ===================================== #
    #  PINNINGS : package specific version  #
    #               management              #
    # ===================================== #


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

    # ⟩ 2025/01/12 : asymptote problem, ✅ solved
    # ——————————————————————————————————————————————————————————————————————————————— #
    # https://hydra.nixos.org/job/nixpkgs/trunk/asymptote.aarch64-darwin/all
    #
    #  ❌ : https://hydra.nixos.org/build/285057864 (the day I encountered the problem)
    #  ✅ : https://hydra.nixos.org/build/285308175 (1 day afer)
    # 
    #  ✅  Succeeded 	285308175 	2025-01-13 	asymptote-2.95 	aarch64-darwin
    #  ❌  Failed 	    285057864 	2025-01-09 	asymptote-2.95 	aarch64-darwin
    # ——————————————————————————————————————————————————————————————————————————————— #
    # nixpkgs-asymptote.url = "github:NixOS/nixpkgs/aafd5e399e42165b7192b57d1c79e8acf7ae278d";
  };

  outputs = { 
    self, 

    # default input repositories
    nix-darwin, 
    nix-homebrew,
    nixpkgs, 

    # github flakes input
    simple-completion-language-server,
    yt-x,
    helix-source,
    todo,

    # 🚧 ===      pinning     === 🚧
      # nixpkgs-pkg,
    # 🚧 === ---------------- === 🚧
    ... 
  }@inputs: # make them available as inputs.simple-completion-language-server, inputs.[***], ...
  let
    # get system automatically
    # useful for source.defaultPackage.${system}
    system = if builtins ? currentSystem
              then builtins.currentSystem
              else "aarch64-darwin";

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
        (self: super: {
          #                 command                
          # pkg = nixpkgs-pkg.legacyPackages.${system}.pkg;
          # ⓘ use helix from the "master" branch from official github repo instead of unstsable nixpkgs version
          helix = helix-source.packages.${system}.helix;
          #     -------------------------------    
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
        ./functions/hosts.nix
      ];

      # ~ nix config
      # ⓘ ensures that the Nix daemon service is active, enabling secure and efficient multi-user package management on your system
      # error:
       # Failed assertions:
       # - The option definition `services.nix-daemon.enable' in `<unknown-file>' no longer has any effect; please remove it.
       # nix-darwin now manages nix-daemon unconditionally when
       # `nix.enable` is on.
      # services.nix-daemon.enable = true;
      nix.enable = true;

      # ⓘ This line allows you to use the `nix` command with flakes.
      nix.settings.experimental-features = "nix-command flakes";

      # ⓘ This line ensures that system.configurationRevision is set to the most accurate revision of your configuration:
      #   1. Uses `self.rev` if the flake is at a clean Git commit.
      #   2. Falls back to `self.dirtyRev` if there are uncommitted changes.
      #   3. Defaults to `null` if no revision information is available.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # ⓘ M1 processor binaries
      nixpkgs.hostPlatform = "aarch64-darwin";

      # ⚠️ Used for backwards compatibility, please read the changelog before changing.
      system.stateVersion = 5;

      # ~ Users
      # &⟩ instable
      # ⓘ defines the user instable
      users.users.instable = {
        home = "/Users/instable";
        name = "instable";
        # config = "/Users/instable/.config";
        # custom = "/Users/instable/.custom";
      };
      environment.variables.XDG_CONFIG_HOME = "/Users/instable/.config";
      environment.variables.XDG_CACHE_HOME = "/Users/instable/.cache";
      environment.variables.XDG_DATA_HOME = "/Users/instable/.data";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#instables-MacBook-Air
    # $ darwin-rebuild switch --flake ~/.config/nix
    darwinConfigurations."instables-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
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
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."instables-MacBook-Air".pkgs;
  };
}
