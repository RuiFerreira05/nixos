{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    lazygit
    ripgrep
    fzf
    btop
    neofetch
    vscode
    neovim
    spotify
    vesktop
    google-chrome
    qbittorrent
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "RuiFerreira05";
	email = "ruimf.05@gmail.com";
      };
    };
  };

  #xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink 
  #  "/home/${username}/nixos-config/configs/nvim";


  programs.home-manager.enable = true;
}
