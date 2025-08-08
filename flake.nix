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
              set -euo pipefail
              echo "✅ Dev shell Python para ${system} pronto."
              echo "• python: $(python3 --version 2>/dev/null || true) | uv: $(uv --version 2>/dev/null || true) | ruff: $(ruff --version 2>/dev/null || true)"
              # datadog-ci (for repo metadata uploads)
              if ! command -v datadog-ci >/dev/null 2>&1; then
                echo "➡️  Instalando @datadog/datadog-ci via npm (global no devShell)…"
                npm install -g @datadog/datadog-ci >/dev/null 2>&1 || echo "⚠️  Falha ao instalar datadog-ci; verifique o npm/node"
              fi
              command -v datadog-ci >/dev/null 2>&1 && datadog-ci --version || true
              if [ -f pyproject.toml ] || [ -f requirements.txt ]; then
                if [ ! -d .venv ]; then
                  echo "➡️  Criando .venv com uv…"
                  uv venv --python="$(command -v python3)" .venv
                fi
                source .venv/bin/activate
                # Sincroniza dependências só na primeira vez neste diretório
                if [ -f pyproject.toml ]; then
                  echo "➡️  uv sync (pyproject.toml)…"
                  uv sync
                elif [ -f requirements.txt ]; then
                  echo "➡️  uv pip install -r requirements.txt…"
                  uv pip install -r requirements.txt
                fi
              fi

              echo "🟢 Ambiente pronto. Use 'deactivate' para sair da venv, 'exit' para sair do devShell."
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
