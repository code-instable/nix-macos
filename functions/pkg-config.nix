{config, pkgs, lib, ...}:
let
  # PKG_CONFIG_PATH_cache = "${config.users.users.instable.home}/.PKG_CONFIG_PATH-cache.txt";
  PKG_CONFIG_PATH_script = ../scripts/PKG_CONFIG_PATH.nu;
  PKG_CONFIG_PATH_cache = ../data/PKG_CONFIG_PATH-cache.txt;
  
  create_pkg_config_path_zsh_script = ''
    printf "\n\033[1;33m⟩ Looking for PKG-CONFIG library paths: \n\033[0m" >&2
    # ⓘ generate the `~/.config/nix/data/.PKG_CONFIG_PATH-cache.txt` file
    # nu "~/.config/nix/scripts/PKG_CONFIG_PATH.nu"
    if nu ${PKG_CONFIG_PATH_script}; then
      printf "\n\033[1;32m✔ Nu script executed successfully.\n\033[0m" >&2
    else
      printf "\n\033[1;31m✘ Nu script execution failed.\n\033[0m" >&2
    fi
    printf "\n saving these in a cache file..." >&2
  '';

in
{
    # https://www.reddit.com/r/Nix/comments/1i3h4zh/comment/m7wfhj7
    # https://github.com/LnL7/nix-darwin/blob/master/modules/system/activation-scripts.nix#L121-L128 
    # list of script names that can be executed by the user :
    #     - extraActivation
    #     - preActivation
    #     - postActivation
    #     - extraUserActivation
    #     - preUserActivation
    #     - postUserActivation
      
    # ❌ system.activationScripts.pkg_config_paths.text = create_pkg_config_path_zsh_script;
    # ✅ system.activationScripts.postActivation.text = 


  system.activationScripts.pkg_config-path.text = create_pkg_config_path_zsh_script;
  # system.activationScripts.postActivation.text = lib.concatStringsSep "\n" [create_pkg_config_path_zsh_script];

  environment.etc."pkg_config_cache".text =  let
    PKG_CONFIG_PATH_CONTENT = if builtins.pathExists PKG_CONFIG_PATH_cache
      then let
        content = builtins.readFile PKG_CONFIG_PATH_cache;
      in if content == ""
         then (builtins.trace "Warning: PKG_CONFIG_PATH_cache is empty" "")
         else (builtins.trace "previous content found for PKG_CONFIG_PATH_cache." content)
      else (builtins.trace "Warning: PKG_CONFIG_PATH_cache does not exist at ${PKG_CONFIG_PATH_cache}" "");
  in ''${PKG_CONFIG_PATH_CONTENT}'';

  environment.variables = {
    PKG_CONFIG_PATH = let
    PKG_CONFIG_PATH_CONTENT = if builtins.pathExists PKG_CONFIG_PATH_cache
      then let
        content = builtins.readFile PKG_CONFIG_PATH_cache;
      in if content == ""
         then (builtins.trace "Warning: PKG_CONFIG_PATH_cache is empty" "")
         else (builtins.trace "previous content found for PKG_CONFIG_PATH_cache." content)
      else (builtins.trace "Warning: PKG_CONFIG_PATH_cache does not exist at ${PKG_CONFIG_PATH_cache}" "");
  in ''${PKG_CONFIG_PATH_CONTENT}'';
  };
}
