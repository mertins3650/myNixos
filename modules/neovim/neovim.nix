{ self, inputs, ... }:
{
    imports = [
        ./lsp.nix
    ];

    flake.nixosModules.neovim = { pkgs, ... }: {
        programs.neovim = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim;
        };
    };

    perSystem = { pkgs, ... }: {
        packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;
            settings = {
                imports = [
                    self.modules.neovim.lsp
                ];
            };
        };
    };
}
