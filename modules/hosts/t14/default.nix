
{ self, inputs, ... }: {
  flake.nixosConfigurations.t14 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.t14Configuration
    ];
  };
}
