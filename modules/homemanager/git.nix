{ ... }:
{
    flake.homeModules.git = {
  programs = {
    git = {
      enable = true;
      settings = {
	user = {
	  name = "Simon Mertins";
	  email = "simon@mertins.net";
};
};
    };
};
};
}
