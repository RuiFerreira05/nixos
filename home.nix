{
  config,
  pkgs,
  username,
  inputs,
  ...
}:
let
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    glib
    lazygit
    ripgrep
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
    networkmanagerapplet
    hyprlock
    hypridle
    nixfmt
    zed-editor
    nil
    nixd
    bat
    trayscale
    gsettings-desktop-schemas
    onedriver
    rclone
    ripgrep
    tree
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.obsidian = {
    enable = true;
  };

  #services.gnome-keyring = {
  #  enable = true;
  #};

  programs.lazydocker = {
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
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      nixconf = "sudo nvim ~/nixos-conf/configuration.nix";
      nixflake = "sudo nvim ~/nixos-conf/flake.nix";
      nixhome = "sudo nvim ~/nixos-conf/home.nix";
      nixswitchold = "sudo nixos-rebuild switch --flake ~/nixos-conf/";
      nixtestold = "sudo nixos-rebuild test --flake ~/nixos-conf/";
      nixupdateold = "nix flake update ~/nixos-conf/";
      nixcleanallold = "sudo nix-collect-garbage -d";
      hyprconf = "sudo nvim ~/nixos-conf/config/hypr/hyprland.conf";
      codenix = "code -r ~/nixos-conf/";
      zednix = "zed -r ~/nixos-conf/";
      nixswitch = "nh os switch --ask ~/nixos-conf/";
      nixtest = "nh os test ~/nixos-conf/";
      nixcleanall = "nh clean all";
      nixupdate = "nh os switch --ask --update ~/nixos-conf/";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
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

        # -----------------------------------------------------------------------------
        # FZF POWERPACK
        # -----------------------------------------------------------------------------

        # 1. FO: Open any file in Neovim (with preview)
        # Usage: fo
        fo() {
          IFS=$'\n' out=("$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
          key=$(head -1 <<< "$out")
          file=$(head -2 <<< "$out" | tail -1)
          if [ -n "$file" ]; then
            ${pkgs.neovim}/bin/nvim "$file"
          fi
        }

        # 2. FCD: cd into any directory (recursive)
        # Usage: fcd
        fcd() {
          local dir
          dir=$(find . -maxdepth 5 -type d -not -path '*/.*' | fzf +m --preview 'tree -C {} | head -200') && cd "$dir"
        }

        # 3. FCO: Checkout Git Branch
        # Usage: fco
        fco() {
          local tags branches target
          branches=$(git branch --all | grep -v HEAD) || return
          target=$(echo "$branches" | fzf -d $(( 2 + $(echo "$branches" | wc -l) )) +m) || return
          git checkout $(echo "$target" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
        }

        # 4. FGL: Interactive Git Log (Enter to view commit, Ctrl-c to copy hash)
        # Usage: fgl
        fgl() {
          git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
          fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
          --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
            {}
      FZF-EOF"
        }

        # 5. FH: Better History Search (Ctrl-r replacement)
        # Usage: fh
        fh() {
          print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
        }

        # 6. FENV: Show Environment Variables
        # Usage: fenv
        fenv() {
          env | fzf --preview 'echo {}'
        }
    '';
  };

  home.file = {
    ".p10k.zsh".source = ./config/p10k.zsh;
    ".local/share/wallpapers".source = ./wallpapers;
  };

  xdg.configFile = {
    "hypr".source = link "/home/${username}/nixos-conf/config/hypr";
    "rofi".source = link "/home/${username}/nixos-conf/config/rofi";
    "waybar".source = link "/home/${username}/nixos-conf/config/waybar";
    "lazygit".source = link "/home/${username}/nixos-conf/config/lazygit";
  };

  gtk = {
    enable = true;

    # 1. Do NOT set a package for Adwaita. It is built-in.
    # Just telling GTK to use "Adwaita" is enough.
    theme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };

    # 2. Keep these, they help legacy apps
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };

  programs.home-manager.enable = true;
}
