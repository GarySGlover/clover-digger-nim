{
  description = "Flake for setting up Nim for PI Pico Development";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  # inputs.extras.url = "github:GarySGlover/flakes"; # Not needed whiel using nimble for packages

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    # extras,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pico-sdk151 = with pkgs; (pico-sdk.overrideAttrs (o: rec
        {
          pname = "pico-sdk";
          version = "1.5.1";
          src = fetchFromGitHub {
            fetchSubmodules = true;
            owner = "raspberrypi";
            repo = pname;
            rev = version;
            sha256 = "sha256-GY5jjJzaENL3ftuU5KpEZAmEZgyFRtLwGVg3W1e/4Ho=";
          };
        }));
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nim
          nimble
          pico-sdk151
          gnumake
          clang
          libclang
          cmake
          gcc-arm-embedded
          minicom # Doesn't work, needs to be added to nimble package
          picotool # Doesn't work, needs to be added to nimble package
          # extras.packages.${system}.futhark # Currently using nimble for packages
          # extras.packages.${system}.piconim # Currently using nimble for packages
        ];
        shellHook = ''
          export PICO_SDK_PATH="${pico-sdk151}/lib/pico-sdk"
        '';
      };
    });
}
