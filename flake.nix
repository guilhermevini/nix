{
  description = "guilhermevini macOS by nix)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShell {
            name = "guilherme-python";
            buildInputs = with pkgs; [
              uv
              ruff
            ];

            shellHook = ''
              echo "✅ Dev shell Python para ${system} pronto."
              echo "• python: $(python3 --version 2>/dev/null || true) | uv: $(uv --version 2>/dev/null || true) | ruff: $(ruff --version 2>/dev/null || true)"
            '';
          };
        });

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          world = pkgs.buildEnv {
            name = "guilherme-world";
            paths = with pkgs; [
              bat
              neovim
              aws-vault
              kubernetes-helm
              direnv
              imagemagick
              wget
              # pandoc
              # tectonic
              # graphviz
              # requirements
              python313
              # need python
              awscli2
              ansible
              google-cloud-sdk
            ];
          };
        });
    };
}
