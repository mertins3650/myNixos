
{ ... }: {
  flake.nixosModules.base = { pkgs,  ...}: {
	
  environment.systemPackages = with pkgs; [
kitty
    unzip 
    vim
        zip
    file-roller
  ];
  };
}
