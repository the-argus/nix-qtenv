{
  description = "C++ Hello World";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }: let
    supportedSystems = let
      inherit (flake-utils.lib) system;
    in [
      system.aarch64-linux
      system.x86_64-linux
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShell =
        pkgs.mkShell.override
        {
          stdenv = pkgs.clangStdenv;
        }
        {
          packages = with pkgs; [
            # qtcreator # if the environment works, qtcreator should also
            cmake
            gnumake
            # libsForQt5.qt5.qtbase
            # libsForQt5.qt5.qtbase.dev
            # libsForQt5.qt5.qtbase.bin
            extra-cmake-modules
            qt6.qtbase.dev
            qt6.qtbase
            qt6.qmake
            qt6.qtconnectivity.dev
            qt6.qtconnectivity
            libsodium
            libsecret
            libcxx
          ];

          shellHook = ''
            export QT_PLUGIN_PATH=${pkgs.qt6.qtbase}/lib/qt-6/plugins:$QT_PLUGIN_PATH
            # export QT_PLUGIN_PATH=${pkgs.libsForQt5.qt5.qtbase.bin}/lib/qt-${pkgs.libsForQt5.qt5.qtbase.qtCompatVersion}/plugins:$QT_PLUGIN_PATH
          '';
        };

      formatter = pkgs.alejandra;
    });
}
