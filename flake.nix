# This flake was initially generated by fh, the CLI for FlakeHub (version 0.1.9)
{
  
  description = "Nspawn wrapper utility for nspawn.org";

  
  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*.tar.gz";

    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
  };

  
  outputs = { self, flake-schemas, nixpkgs }:
    let
      pname = "nspawn";
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        inherit system;
      });
    in {

      packages = forEachSupportedSystem ({pkgs,...}: {
        default = pname;

        ${pname} = pkgs.stdenvNoCC.mkDerivation {
          name = pname;
          version = "0.6";
          src = pkgs.fetchFromGitHub {
            owner = pname;
            repo = pname;
            rev = "0.6";
            hash = "sha256-V9PK4Qe7NoiwPTC9//3D14q/aC7tfwX1BzxjmOLk56Y=";
          };
          patches = [./nspawn.patch];
          nativeBuildInputs = [pkgs.makeWrapper];
          depsHostTarget = with pkgs; [systemd gnupg coreutils];
          buildPhase = ''
            mkdir -p $out/bin && cp $src/${pname} $out/bin && wrapProgram $out/bin/${pname} --prefix PATH : $out/bin
          '';
        };

        ${pname}-unwrapped = ${pname}.overrideAttrs (finalAttrs: oldAttrs: { buildPhase = ''mkdir -p $out/bin && cp $src/${pname} $out/bin'' })
      });


      schemas = flake-schemas.schemas;

      formatter = forEachSupportedSystem ({ pkgs, system, ... }: {
        ${system} = pkgs.nixpkgs-fmt;
      });

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nixpkgs-fmt
            nil
          ];
        };
      });
    };
}
