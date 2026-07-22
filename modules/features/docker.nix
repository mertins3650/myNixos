{...}: {
  flake.nixosModules.docker = {...}: {
    virtualisation.docker.enable = true;
    systemd.services.docker = {
      after = ["network.target"];
      wants = [];
    };
  };
}
