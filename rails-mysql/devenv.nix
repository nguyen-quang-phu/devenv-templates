{
  pkgs,
  lib,
  ...
}: {
  languages.ruby.enable = true;
  dotenv.enable = true;

  # Use a specific Ruby version.
  # languages.ruby.version = "3.2.1";

  # Use a specific Ruby version from a .ruby-version file, compatible with rbenv.
  languages.ruby.versionFile = ./.ruby-version;

  # turn off C tooling if you do not intend to compile native extensions, enabled by default
  # languages.c.enable = false;

  enterShell = ''
    # Automatically run bundler upon enterting the shell.
    bundle
  '';
  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql80;
  services.mysql.initialDatabases = [{name = "gigadmin_development";}];
  services.mysql.ensureUsers = [
    {
      name = "gigadmin_development";
      password = "gigadmin_development";
      ensurePermissions = {"gigadmin_development.*" = "ALL PRIVILEGES";};
    }
  ];
  services.mysql.settings = {
    mysqld = {
      sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION";
    };
  };
  packages = with pkgs;
    [
      curl
      git
      gitleaks
      glab
      graphviz
      imagemagick
      just
      libyaml
      ngrok
      openssl
      redis
    ]
    # Add required dependencies for macOS. These packages are usually provided as
    # part of the Xcode command line developer tools, in which case they can be
    # removed.
    # For more information, see the `--install` flag in `man xcode-select`.
    ++ lib.optionals pkgs.stdenv.isDarwin [pkgs.libllvm];
}
