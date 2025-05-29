{ pkgs, ...}:
{
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
        lmodern
        lmmath
        xits-math
        fira-math
        julia-mono
        newcomputermodern
    ];
}
