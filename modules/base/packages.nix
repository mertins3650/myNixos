
{ ... }: {
  flake.nixosModules.base = { pkgs,  ...}: {
	
  environment.systemPackages = with pkgs; [
            self.packages.${pkgs.system}.neovimDynamic
    unzip 
    vim
        zip
    file-roller
  ];
  };
}
