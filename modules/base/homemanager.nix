{ self, ... }: {
    flake.nixosModules.homemanager = { ... }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.simonm.imports = [
            self.homeModules.simonm
        ];
    };
}
