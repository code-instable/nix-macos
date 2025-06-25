{
  ...
}:
{
  home.stateVersion = "24.11";

  home = {
    username = "instable";
    homeDirectory = "/Users/instable";
  };
  
  imports = [
    ./instable/firefox.nix
  ];

  programs.home-manager.enable = true;

nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home.file.".Rprofile".text = /* R */
  ''
    # This file is sourced at the start of R sessions
    options(browser="open --background -a 'Zen Browser'")
    # HTTPGD
    # size: zen browser with sideberry
    options(httpgd.width = 1735)
    options(httpgd.height = 1045)
    # options(httpgd.port = 8080)
    # httpgd::hgd(silent = TRUE)
    # httpgd::hgd_browse()
  '';
}
