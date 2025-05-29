{lib, config,...}:
let
    macbook_air_m1_network_services = [
        "USB 10/100/1000 LAN"
        "Thunderbolt Bridge"
        "Wi-Fi"
    ];

    # Helper to create DNS check for each interface
    dns_check_all_interfaces_script = lib.concatStrings (map (interface: /* zsh */
    ''
        printf "\n\nchecking DNS for \033[1;32m${interface}\033[0m..." >&2
        if networksetup -listallnetworkservices | grep -q "${interface}"; then
          printf "current DNS for ${interface} is \n%s" "$(networksetup -getdnsservers '${interface}')" >&2
        fi
    '') macbook_air_m1_network_services);

    dns_script = /* zsh */
    ''
        printf "\n\033[1;33m⟩ Flushing DNS Cache: \n\033[0m" >&2

        echo "flushing cache..." >&2
        sudo dscacheutil -flushcache && printf "\n\033[1;32m✔ succeeded\n\033[0m" >&2 || printf "\n\033[1;31m✘ failed\n\033[0m" >&2
        echo "killing mDNSResponder"
        sudo killall -HUP mDNSResponder && printf "\n\033[1;32m✔ succeeded\n\033[0m" >&2 || printf "\n\033[1;31m✘ failed\n\033[0m" >&2
        
        printf "\n\033[1;33m⟩ Checking DNS values: \n\033[0m" >&2
        ${dns_check_all_interfaces_script}
    '';

    one_dot_one_porn_block = [
        # 1.1.1.1 Family (porn block)
        "1.1.1.3"
        "1.0.0.3"
        "2606:4700:4700::1113"
        "2606:4700:4700::1003"
    ];
in
{
    # System Shell Aliases
    environment.shellAliases = {
        exa = "eza --icons";
        rebuild = "darwin-rebuild switch --flake ${config.users.users.instable.home}/.config/nix --cores 7 --verbose -j 7";
        restart = "source ${config.users.users.instable.home}/.zshrc";
        yz="yazi";
        marta="open -a Marta";
        m="micromamba";
        zen="open -a 'Zen Browser'";
        pdf="zathura";
        homerebuild="home-manager switch -f ${config.users.users.instable.home}/.config/nix/home.nix";
        aicode="aichat --model 'github:codestral-2501' --role '%code%'";
        deepseek="aichat --model 'github:deepseek-r1'";
        aishell="aichat --model 'github:codestral-2501' --role '%shell%'";
        ai="aichat --model 'github:mistral-nemo'";
    };

    # Settings
    # needs `system.primaryUser` — to apply user-level settings from root (darwin-rebuild)
    system.defaults = {
        dock = {
            autohide = true;
            show-recents = false;
            static-only = true;
            # persistent-apps = [
            # ];
            persistent-others = [];
        };
        WindowManager = {
            GloballyEnabled = false;
            HideDesktop = true;
            StandardHideDesktopIcons = true;
            StandardHideWidgets = true;
            EnableStandardClickToShowDesktop = false;
            AppWindowGroupingBehavior = true; # false means "One at a time" true means "All at once"
        };
        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    };
    system.startup.chime = false;

    # Networking
    networking.dns = one_dot_one_porn_block;

    networking.knownNetworkServices = macbook_air_m1_network_services;
    
    system.activationScripts.flushDNS.text = dns_script;

    #  `sudo systemsetup -listtimezones | fzf`
    time.timeZone = "Europe/Brussels";

    # https://mynixos.com/nix-darwin/option/system.defaults.CustomSystemPreferences
    system.defaults.CustomSystemPreferences = {};
}
