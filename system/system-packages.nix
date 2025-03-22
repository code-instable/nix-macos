{ pkgs, inputs, lib, ... }:
let
  libs = with pkgs; [
    pandoc # pdf/html generation
    pinentry-tty # for rbw bitwarden tool (dependency)
    readline # used for rpy2
    zlib # compression
    # java
    # zulu
    temurin-jre-bin-11 # ▶ revanced-cli
    temurin-jre-bin # ▶ ltex-ls-plus

    inkscape # LaTeX svg include

    tesseract
    # poppler # pdftotext
  ];

  editors = with pkgs; [
    # neovim                      # sheitan
    vscode # editor of choice
    micro # simple editor in cli
    helix # nvim made simple
  ];

  devTools = with pkgs; [
    texliveFull # latex
    # scriptisto          # run scripts in any language
    micromamba # faster conda
    pkg-config # compiling flags generator (for libraries)
    # luarocks              # lua package manager
    pnpm # faster npm
    lua5_4 # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/interpreters/lua-5/default.nix
    # https://www.lua.org/versions.html#5.4
    gfortran14
    typescript
    prettierd
    go
    rustc
    android-tools
    zig
    quarto
    typst
    deno
    nodejs
    plantuml
    autoconf
    inputs.latex2utf8.packages.${system}.lutf # https://github.com/code-instable/latex2utf8
  ];

  __cli-tools-bat = with pkgs; [
    bat # better cat
    bat-extras.prettybat
    bat-extras.batwatch
    bat-extras.batpipe
    bat-extras.batman
    bat-extras.batgrep
    bat-extras.batdiff
  ];

  __cli-tools-files = with pkgs; [
    zoxide # better cd
    gdu # better du
    eza # better ls
    yazi # file manager
    fd # better find
    lftp # ftp protocols, used for website deployment
    fswatch
  ];

  __cli-tools-emails = with pkgs; [
    neomutt # email client
    mutt-wizard # email setup within cli
    lynx # cli web browser
    notmuch
    abook
    urlscan
    gnupg # secure store passwords
  ];

  __cli-tools-shell = with pkgs; [
    zinit # zsh plugin manager
    nushell # data processing within cli
    zellij # terminal multiplexer
  ];

  __cli-tools-general_purpose = with pkgs; [
    ripgrep # better grep
    ripgrep-all # ripgrep for all files |  `rga [pattern] [dir/file]`
    fzf # fuzzy finder
    yq-go # better jq
    wget # better curl
  ];

  __cli-tools-dev = with pkgs; [
    tokei # code repository statistics
    delta # better diff
    gh # github cli
    lazygit # git integration for helix
    serpl # find and replace in a project
  ];

  __cli-tools-img = with pkgs; [
    imagemagick
    ffmpeg
    djvu2pdf
    #   `nix run nixpkgs#djvu2pdf -- --input djvu_file.djvu --output pdf_file.pdf`
  ];

  __cli-tools-apps = with pkgs; [
    numi # simple calculator within cli, and app
    inputs.yt-x.packages."${system}".default # https://github.com/Benexl/yt-x
    inputs.todo.defaultPackage.${system}     # https://github.com/sioodmy/todo
    inputs.presenterm.packages.${system}.default # https://github.com/mfontanini/presenterm
    newsraft
    yt-dlp
    terminal-notifier
    btop # better top
    tlrc # tldr
    obs-cmd # control obs from command line
    aichat
  ];

  __cli-tools-passwords = with pkgs; [
    rbw # bitwarden cli client
    #                       `rbw get [entry] --ignorecase --field=[field]`
    #                       `rbw get [entry] --ignorecase --full`
    #                       `rbw get [entry] --ignorecase --raw` (for json)
    #                       `rbw get [entry] --ignorecase --clipboard`
    passh # pass-in password to command : used with rbw to login (website)
    # rofi-rbw 
  ];

  cli-tools = with pkgs;
    [
      # ⓘ one off command :
      # nix-shell -p vivid --run "vivid generate snazzy > ~/Github/TerminalConfig/zenful-zsh/.custom/style/vivid-snazzy-ls"
      # vivid               # Generate LS_COLORS
    ] ++ __cli-tools-bat ++ __cli-tools-files ++ __cli-tools-passwords
    ++ __cli-tools-apps ++ __cli-tools-img ++ __cli-tools-general_purpose
    ++ __cli-tools-shell ++ __cli-tools-dev ++ __cli-tools-emails;

  lsp = with pkgs; [
    # ⓘ LaTeX
    # ltex-ls               # LTeX language server
    ltex-ls-plus # modern LTeX fork / continuation
    texlab # latex language server
    bibtex-tidy # formatter
    # ⓘ Nix
    nixd # nix language server
    nixfmt # nix formatter
    direnv
    nix-direnv
    nix-direnv-flakes
    nil # nix language server (used for helix)
    # ⓘ ShellScript
    shellcheck # shellscript linter
    bash-language-server
    # ⓘ Json
    jq-lsp # jq language server
    vscode-langservers-extracted # used for helix (vscode-json-language-server)
    # ⓘ Python
    # ruff              # python fast linter
    ruff-lsp
    pyright
    # ⓘ Lua
    # lua-language-server
    # ⓘ Go
    gopls
    golangci-lint
    delve # go debugger
    # ⓘ Markdown
    markdown-oxide
    marksman
    # ⓘ Nu
    nufmt
    # ⓘ Kdl
    kdlfmt
    # ⓘ Typst
    tinymist
    typstyle
    # ⓘ Astro
    astro-language-server
    # ⓘ Snippets
    # not from nixpkgs, inherited from simple-completion-language-server.defaultPackage, see `flake.nix`
    inputs.simple-completion-language-server.defaultPackage.${system}
    # ⓘ Perl
    perlnavigator
    # ⓘ Rust
    rust-analyzer
    lldb
    yaml-language-server
    ansible-language-server
  ];

  dailyUseApps = with pkgs; [
    aldente # battery management
    bartender # toolbar management
    raycast # better spotlight
    mkalias # easy aliases for cli
    mas # mac app store cli
    spotify
    scrcpy # mirror android screen
    # obsidian # note app
    audacity # sound app
    sox # record audio in cli
    discord
    localsend
    # typora
    # calibre
    mailspring
  ];

  # ============ ⓘ info only ⓘ ============
  install_on_brew = with pkgs; [
    ghostty # is marked as broken, refusing to evaluate
    kitty # ⚠️ INSTALL BREW VERSION | otherwise : not found when launching from raycast/launcher
    skimpdf # ⚠️ INSTALL BREW VERSION
  ];
  # =======================================

  # ⚠️ obs-studio not available on macos
  obs_linux = with pkgs; [
    obs-studio
    obs-studio-plugins.obs-tuna
    obs-studio-plugins.input-overlay
    obs-studio-plugins.obs-composite-blur
    obs-studio-plugins.obs-gradient-source
    obs-studio-plugins.waveform
    obs-studio-plugins.obs-text-pthread
    obs-studio-plugins.obs-vintage-filter
    obs-studio-plugins.obs-source-switcher
  ];

  linux = with pkgs; [
    wolfram-engine # for macos use brew
    mathematica
    firefox
    ghostty
    foliate # ebook reader (modern)
    ventoy
    davinci-resolve
    dorion # discord rust client
  ];

  fonts = with pkgs;
    [
      # nerdfonts             # fonts with icons
      # now nerdfonts are separated in individual packages :
      nerd-fonts.jetbrains-mono
    ];

  # language specific packages
  lua_pkgs = with pkgs; [
    lua54Packages.luarocks
    lua54Packages.luafilesystem
    lua54Packages.stdlib
    lua54Packages.serpent
    lua54Packages.luautf8
    lua54Packages.luasystem
    lua54Packages.luacheck
    lua54Packages.lua_cliargs
  ];

  # &⟩ gather all packages, and differentiate between linux and macos
  multi_platform_pkgs = libs ++ devTools ++ cli-tools ++ editors ++ dailyUseApps
    ++ fonts ++ lsp ++ lua_pkgs;
  linux_pkgs = with pkgs; [vlc] ++ obs_linux;
  # ⓘ do not use nix for linux for now
  macos_pkgs = [ ];
in {
  # ⓘ allow non open-source packages
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #    "obsidian"
  # ];

  environment.variables.QUARTO_R = "/usr/local/bin";

  # ?⟩ if on linux
  environment.systemPackages = if pkgs.stdenv.isLinux then
    multi_platform_pkgs ++ linux ++ linux_pkgs
    # ?⟩ if on macos
  else
    multi_platform_pkgs ++ macos_pkgs;
}
