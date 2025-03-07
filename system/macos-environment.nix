{lib,...}:
let
    macbook_air_m1_network_services = [
        "USB 10/100/1000 LAN"
        "Thunderbolt Bridge"
        "Wi-Fi"
    ];

    # Helper to create DNS check for each interface
    dnsChecks = lib.concatStrings (map (interface: ''
        echo "checking DNS for ${interface}..." >&2
        if networksetup -listallnetworkservices | grep -q "${interface}"; then
          echo "current DNS for ${interface} is $(networksetup -getdnsservers '${interface}')" >&2
        fi
    '') macbook_air_m1_network_services);

    one_dot_one_porn_block = [
        # 1.1.1.1 Family (porn block)
        #
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
        rebuild = "darwin-rebuild switch --flake ~/.config/nix";
        restart = "source ~/.zshrc";
        yz="yazi";
        marta="open -a Marta";
        m="micromamba";
    };

    # Settings

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

    # # 5. Flush DNS cache
    # `sudo dscacheutil -flushcache`
    # `sudo killall -HUP mDNSResponder`
    networking.dns = one_dot_one_porn_block;

    networking.knownNetworkServices = macbook_air_m1_network_services;
    system.activationScripts.flushDNS.text =''
        printf "\nflushing DNS cache...\n" >&2
        sudo dscacheutil -flushcache
        sudo killall -HUP mDNSResponder
        echo "current DNS is $(networksetup -getdnsservers )" >&2
        ${dnsChecks}
    '';

}
