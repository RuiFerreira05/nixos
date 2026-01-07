{ config, pkgs, username, inputs, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  
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
    zsh-powerlevel10k
    gcr
  ];

  services.gnome-keyring = {
    enable = true;
  };

  programs.zen-browser = {
    enable = true;
  };

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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    plugins = [
      {
        name = "powerlevel10k";
	src = pkgs.zsh-powerlevel10k;
	file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  home.file = {
    ".p10k.zsh".source = ./p10k.zsh;
  };

  #xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink 
  #  "/home/${username}/nixos-config/configs/nvim";


  programs.home-manager.enable = true;
}
