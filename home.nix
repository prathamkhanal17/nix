{ config, pkgs, ... }:

{
  home.username = "prathamk";
  home.homeDirectory = "/home/prathamk";
  home.stateVersion = "25.05";

  home.packages = [
   pkgs.openssh # You can add more packages here if needed
  ];

  programs.zsh = {
    enable = true;
    # enableCompletions = true;
    # autosuggestions.enable = true;
    # syntaxHighlighting.enable =true;
    shellAliases = {
      ls = "ls --color=auto";
      uphm = "home-manager switch -b backup --flake ~/nix#prathamk";
      upfl = "nix flake update";
      upfn = "sudo nixos-rebuild switch --flake ~/nix#nixos";
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git"  ]; # You can add plugins like 'git', 'z', 'fzf' here
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "prathamkhanal17";
    userEmail = "prathamkhanal962@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.home-manager.enable = true;
}
