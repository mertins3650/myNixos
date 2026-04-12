
{ ... }: {
  flake.nixosModules.base = { pkgs,  ...}: {
	
  environment.systemPackages = with pkgs; [
    unzip 
    vim
        zip
    file-roller
  ];
  };
}
