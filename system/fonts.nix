{pkgs, ...}: {
  fonts.packages = with pkgs; [
    # (
    #     # ⓘ install the following nerd fonts onto the system
    #     pkgs.nerdfonts.override {
    #         fonts = [
    #             "JetBrainsMono"
    #         ];
    #     }
    # )
    # use instead :
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.symbols-only
    nerd-fonts.zed-mono
    nerd-fonts.noto
    nerd-fonts.tinos
    nerd-fonts.lilex
    nerd-fonts.arimo
    nerd-fonts.lekton
    nerd-fonts.go-mono
    nerd-fonts.meslo-lg
    nerd-fonts.geist-mono
    nerd-fonts.victor-mono
    nerd-fonts.roboto-mono
    nerd-fonts.intone-mono
    nerd-fonts.envy-code-r
    nerd-fonts.atkynson-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.inconsolata-lgc
    nerd-fonts.dejavu-sans-mono
    lmodern
    lmmath
    xits-math
    fira-math
    julia-mono
    newcomputermodern
  ];
}
