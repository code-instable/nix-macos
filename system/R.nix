{pkgs, lib, ...}:
let
  pkgs-rstats_on_nix = import (fetchTarball
    {
      name = "rstats-on-nix-2025-04-11";
      url = "https://github.com/rstats-on-nix/nixpkgs/archive/2025-04-11.tar.gz";
      # sha256 = lib.fakeSha256;
      sha256 = "sha256:0y60qsq1mwdfi8bhlbw8zbwxkifgyki1bx1pfv1sxp2v6wk6r1s1";
    }
  ) {
    system = pkgs.system;
  };
  
  fdadapt = (pkgs-rstats_on_nix.rPackages.buildRPackage {
    name = "FDAdapt";
    src = pkgs.fetchgit {
      url = "https://github.com/sunnywang93/FDAdapt";
      rev = "5168a635e630692e30a26bf9a7a31d3dd9716b74";
      sha256 = "sha256-uOM+SGozp+QFlXJ7LdLwsFL80LswU2aIO3m6sHHpcLk=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs-rstats_on_nix.rPackages) abind fdapace glmnet interp MASS np pracma purrr;
    };
  });
  direg = (pkgs-rstats_on_nix.rPackages.buildRPackage {
    name = "direg";
    src = pkgs.fetchgit {
      url = "https://github.com/sunnywang93/direg";
      rev = "2dec6f98f39b0e4c177a3f2043f5cfa2533c8dcf";
      sha256 = "sha256-sMp+75md4tCVBRWszJXqBnM3uS5/SsjgWubkN93wzF0=";
    };
    propagatedBuildInputs = builtins.attrValues { inherit (pkgs-rstats_on_nix.rPackages) ; };
  });
  somebm = (pkgs-rstats_on_nix.rPackages.buildRPackage {
    name = "somebm";
    src = pkgs.fetchgit {
      url = "https://github.com/cran/somebm";
      rev = "03584b24dee8081f08a0cde456edcc8419aba494";
      sha256 = "sha256-QqSk/bmbDpquHJfHqimCcJcj/4QKdqQLBLqKCRZzn6s=";
    };
    propagatedBuildInputs = builtins.attrValues { inherit (pkgs-rstats_on_nix.rPackages) ; };
  });
  adaptiveFTS = (pkgs-rstats_on_nix.rPackages.buildRPackage {
    name = "adaptiveFTS";
    src = pkgs.fetchgit {
      url = "https://github.com/hmaissoro/adaptiveFTS";
      rev = "02995403bb4a9ec09718a1b6cfa32c7a3f53fb06";
      sha256 = "sha256-YMt5kSnDoAELTfcb25DkI3Ba3fAwznbgDer2mxJdnRM=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs-rstats_on_nix.rPackages)
        caret data_table fastmatrix MASS Rcpp Rdpack RcppArmadillo;
    } ++ [ pkgs.llvmPackages.openmp ];
  });
  httpgd = (pkgs-rstats_on_nix.rPackages.buildRPackage {
    name = "httpgd";
    src = pkgs.fetchgit {
      url = "https://github.com/nx10/httpgd";
      rev = "dd6ed3a687a2d7327bb28ca46725a0a203eb2a19";
      sha256 = "sha256-vs6MTdVJXhTdzPXKqQR+qu1KbhF+vfyzZXIrFsuKMtU=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs-rstats_on_nix.rPackages)
      /*
      # https://github.com/nx10/httpgd/blob/master/DESCRIPTION
      LinkingTo: 
        unigd,
        cpp11 (>= 0.2.4),
        AsioHeaders (>= 1.22.1)
      */
      unigd 
      AsioHeaders
      cpp11
      ;
    };
  });
  deconvolve = (pkgs-rstats_on_nix.rPackages.buildRPackage {
      name = "deconvolve";
      src = pkgs.fetchgit {
        url = "https://github.com/timothyhyndman/deconvolve";
        rev = "05a18c54a2a70563c51179db33ef55ef39bf4b5f";
        sha256 = "sha256-wC2LTzIEHZeVXRqYLkoHSHIwre04nhdBw9HhI/cIgN8=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs-rstats_on_nix.rPackages) 
          NlcOptim
          ggplot2
          foreach
          doParallel;
      };
    });

  r_packages =
  # with pkgs-rstats_on_nix.rPackages; [
  builtins.attrValues {
    inherit (pkgs-rstats_on_nix.rPackages) 
    data_table
    rix
    glue
    orthogonalsplinebasis
    mgcv
    Matrix
    MASS
    fda
    fda_usc
    fdapace
    xtable
    survey
    gustave
    progress
    reticulate
    scales
    doParallel
    foreach
    pracma
    ;
    }
    # 𝐑𝐔𝐍𝐓𝐈𝐌𝐄 dependencies
    ++ builtins.attrValues {
    inherit (pkgs-rstats_on_nix.rPackages)
    /* RIX:
    # https://github.com/ropensci/rix/blob/main/DESCRIPTION
    Imports:
      codetools,
      curl,
      jsonlite,
      sys,  # default lib
      utils # default lib
    */
    codetools  # rix dependence
    curl       # rix dependence
    jsonlite   # rix dependence
    /* HTTPGD:
    # https://github.com/nx10/httpgd/blob/master/DESCRIPTION
    Imports: 
      unigd
    */
    unigd # httpgd dependence
    ;
    } ++ [
      adaptiveFTS
      fdadapt
      direg
      somebm
      httpgd
      deconvolve
    ];

  r_with_packages = pkgs-rstats_on_nix.rWrapper.override{ packages = r_packages; };
  
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/all-packages.nix#L10151-L10175 
  radian_with_packages = pkgs-rstats_on_nix.radianWrapper.override {
    # use the 3.13 version explicitly
    # radian = pkgs.python313Packages.radian;
    packages = r_packages;
    wrapR = true;
  };
in 
{
  environment.systemPackages = [
    r_with_packages
    radian_with_packages
    pkgs-rstats_on_nix.quarto
  ];

  environment.etc."R_LIBS".text = builtins.readFile (pkgs.runCommand "r-lib-paths" {} ''
  ${r_with_packages}/bin/Rscript -e 'cat(paste0(.libPaths(), collapse = ":"), sep = "\n")' > $out
  '');

  # setup radian to use the r_with_packages
  # $XDG_CONFIG_HOME/radian/profile

  # a workaround when no radian wrapper
  environment.etc."radian-profile-no_nix_wrapper".text = /* R */
  ''
    options(radian.highlight_matching_bracket = TRUE)
    options(radian.history_search_ignore_case = TRUE)
    # add the r_with_packages to the library paths
    .libPaths(c("${r_with_packages}/lib/R/library", .libPaths()))
    # Also add individual package paths from r_packages
    .libPaths(c(${builtins.concatStringsSep ", " (map (pkg: ''"${pkg}/library"'') r_packages)}, .libPaths()))
    # set the default CRAN mirror to france
    options(repos = c(CRAN = "https://cran.fr.r-project.org"))
  '';

  environment.etc."radian-profile".text = /* R */
  ''
    options(radian.highlight_matching_bracket = TRUE)
    options(radian.history_search_ignore_case = TRUE)
  '';

  environment.etc.".Rprofile".text = /* R */
  ''
    # This file is sourced at the start of R sessions
    options(browser="open -a 'Zen Browser'")
    # HTTPGD
    options(httpgd.port = 8080)
    # size: zen browser with sideberry
    options(httpgd.width = 1735)
    options(httpgd.height = 1045)
    # httpgd::hgd(silent = TRUE)
    # httpgd::hgd_browse()
  '';


  environment.shellAliases = {
     rnix = "radian --r-binary ${r_with_packages}/bin/R --profile /etc/radian-profile-no_nix_wrapper";
     rsave = "radian --r-binary ${r_with_packages}/bin/R --save --profile /etc/radian-profile-no_nix_wrapper";
     r = "radian --profile /etc/radian-profile";
  };
}
