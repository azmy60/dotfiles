{
  description = "Packages installed by arch-bootstrap";

  inputs = {
    nixpkgs.url = "https://releases.nixos.org/nixpkgs/nixpkgs-26.11pre1125786.680275f0bb6a/nixexprs.tar.zst";
    nixgl = {
      url = "github:nix-community/nixGL/4306ae1d15adf3d386f1462b330d4f2648404711";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixgl, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      packages.x86_64-linux.default = pkgs.buildEnv {
        name = "arch-bootstrap-packages";
        paths = with pkgs; [
          hyprland
          ghostty
          hyprlauncher
          hyprshutdown
          nautilus
          neovim
          nixgl.packages.x86_64-linux.default
        ];
      };
    };
}
