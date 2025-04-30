printf "\n\033[1;33m⟩ Looking for PKG-CONFIG library paths: \n\033[0m" >&2
# ⓘ generate the `~/.config/nix/data/.PKG_CONFIG_PATH-cache.txt` file
# nu "~/.config/nix/scripts/PKG_CONFIG_PATH.nu"
if nu ${PKG_CONFIG_PATH_script}; then
    printf "\n\033[1;32m✔ Nu script executed successfully.\n\033[0m" >&2
else
    printf "\n\033[1;31m✘ Nu script execution failed.\n\033[0m" >&2
fi
printf "\n saving these in a cache file..." >&2