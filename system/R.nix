{pkgs, ...}:
let 
  fdadapt = (pkgs.rPackages.buildRPackage {
    name = "FDAdapt";
    src = pkgs.fetchgit {
      url = "https://github.com/sunnywang93/FDAdapt";
      rev = "5168a635e630692e30a26bf9a7a31d3dd9716b74";
      sha256 = "sha256-uOM+SGozp+QFlXJ7LdLwsFL80LswU2aIO3m6sHHpcLk=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) abind fdapace glmnet interp MASS np pracma purrr;
    };
  });
  direg = (pkgs.rPackages.buildRPackage {
    name = "direg";
    src = pkgs.fetchgit {
      url = "https://github.com/sunnywang93/direg";
      rev = "2dec6f98f39b0e4c177a3f2043f5cfa2533c8dcf";
      sha256 = "sha256-sMp+75md4tCVBRWszJXqBnM3uS5/SsjgWubkN93wzF0=";
    };
    propagatedBuildInputs = builtins.attrValues { inherit (pkgs.rPackages) ; };
  });
  somebm = (pkgs.rPackages.buildRPackage {
    name = "somebm";
    src = pkgs.fetchgit {
      url = "https://github.com/cran/somebm";
      rev = "03584b24dee8081f08a0cde456edcc8419aba494";
      sha256 = "sha256-QqSk/bmbDpquHJfHqimCcJcj/4QKdqQLBLqKCRZzn6s=";
    };
    propagatedBuildInputs = builtins.attrValues { inherit (pkgs.rPackages) ; };
  });
  adaptiveFTS = (pkgs.rPackages.buildRPackage {
    name = "adaptiveFTS";
    src = pkgs.fetchgit {
      url = "https://github.com/hmaissoro/adaptiveFTS";
      rev = "02995403bb4a9ec09718a1b6cfa32c7a3f53fb06";
      sha256 = "sha256-YMt5kSnDoAELTfcb25DkI3Ba3fAwznbgDer2mxJdnRM=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages)
        caret data_table fastmatrix MASS Rcpp Rdpack RcppArmadillo;
    } ++ [ pkgs.llvmPackages.openmp ];
  });

  r_packages = with pkgs.rPackages; [
    data_table
    rix
    codetools # rix dependence
    curl # rix dependence
    jsonlite # rix dependence
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
  ] ++ [adaptiveFTS fdadapt direg somebm];

  r_with_packages = pkgs.rWrapper.override{ packages = r_packages; };
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/all-packages.nix#L10151-L10175 
  radian_with_packages = pkgs.radianWrapper.override {
    # use the 3.13 version explicitly
    radian = pkgs.python313Packages.radian;
    packages = r_packages;
    wrapR = true;
  };
in 
{
  environment.systemPackages = [
    # r_with_packages
    radian_with_packages
  ];

  environment.etc."R_LIBS".text = builtins.readFile (pkgs.runCommand "r-lib-paths" {} ''
  ${r_with_packages}/bin/Rscript -e 'cat(paste0(.libPaths(), collapse = ":"), sep = "\n")' > $out
  '');

  # setup radian to use the r_with_packages
  # $XDG_CONFIG_HOME/radian/profile

  environment.etc."radian-profile".text = /* R */
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

  environment.shellAliases = {
     rnix = "radian --r-binary ${r_with_packages}/bin/R --profile /etc/radian-profile";
     rsave = "radian --r-binary ${r_with_packages}/bin/R --save --profile /etc/radian-profile";
  };
}
