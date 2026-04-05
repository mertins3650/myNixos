{ self, inputs, ... }: {
  flake.nixosConfigurations.t490 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.t490Configuration
    ];
  };
}
