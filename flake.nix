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
            buildInputs = with pkgs; [
              bat
              neovim
              awscli2
              aws-vault
              uv                # package manager para Python
              ruff              # linter
              kubernetes-helm   # (alias de 'helm' em alguns canais)
              python313
              direnv
              google-cloud-sdk
              imagemagick
              wget
              pandoc
              tectonic
              ansible
              graphviz
            ];

            # opcional: ajuda no shell
            shellHook = ''
              echo "✅ Dev shell para ${system} pronto."
              echo "• python: $(python3 --version) | uv: $(uv --version || true)"
              echo "• helm: $(helm version --short || true)"
            '';
          };
        });
    };
}