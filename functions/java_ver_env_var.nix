{pkgs, ...}: let
  JAVA_HOME_21 = pkgs.temurin-jre-bin;
  JAVA_HOME_11 = pkgs.temurin-jre-bin-11;
  JAVA_HOME = JAVA_HOME_21;
in {
  environment.variables = {
    JAVA_HOME_11 = "${JAVA_HOME_11}";
    JAVA_HOME_21 = "${JAVA_HOME_21}";
    JAVA_HOME = "${JAVA_HOME}";
  };
  # also print each of them in the console log of the nix switch
  environment.etc."java-environment".text =
    /*
    zsh
    */
    ''
      JAVA_HOME_11=${JAVA_HOME_11}
      JAVA_HOME_21=${JAVA_HOME_21}
      JAVA_HOME=${JAVA_HOME}
    '';
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
}
