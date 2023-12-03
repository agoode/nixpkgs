{ lib
, callPackage
, rustPlatform
, fetchFromGitHub
, protobuf
, darwin
, stdenv
}:
let
  version = "unstable-2023-11-23";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "sshx";
    rev = "2677f7e1fa3b369132cc7f27f6028a04b92ba5cf";
    hash = "sha256-9fo8hNUzJr4gse0J2tw7j+alqE82+y8McADzTkxryWk=";
  };

  mkSshxPackage = { pname, cargoHash, ... }@args:
    rustPlatform.buildRustPackage (rec {
      inherit
        pname
        version
        src
        cargoHash;

      nativeBuildInputs = [ protobuf ];
      buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

      cargoBuildFlags = [ "--package" pname ];
      cargoTestFlags = cargoBuildFlags;

      meta = {
        description = "Fast, collaborative live terminal sharing over the web";
        homepage = "https://github.com/ekzhang/sshx";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [ pinpox kranzes ];
        mainProgram = pname;
      };
    } // args);
in
{
  sshx = mkSshxPackage {
    pname = "sshx";
    cargoHash = "sha256-dA5Aen/qANW8si75pj/RsBknvOo3KDyU5UISAmmcfRE=";
  };

  sshx-server = mkSshxPackage {
    pname = "sshx-server";
    cargoHash = "sha256-1GRWCMXsOzqvORgtwfuywV4wLyX3r4nURhM3Dl5V9Ss=";
  };
}
