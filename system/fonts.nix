{ pkgs, ...}:
{
    fonts.packages = [
        # (
        #     # ⓘ install the following nerd fonts onto the system
        #     pkgs.nerdfonts.override {
        #         fonts = [
        #             "JetBrainsMono"
        #         ];
        #     }
        # )
        # use instead :
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.fira-mono
        pkgs.lmodern
        pkgs.lmmath
        pkgs.xits-math
    ];
}
