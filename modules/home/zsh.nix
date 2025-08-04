{  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      uphm = "home-manager switch -b backup --flake ~/nix#prathamk";
      upfl = "sudo nix flake update";
      upfn = "sudo nixos-rebuild switch --flake ~/nix#legion";
      free = "sudo nix-collect-garbage -d";
      p2n = "nix run github:nix-community/pip2nix -- generate";
      gedit = "gnome-text-editor";
    };



    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git"  ]; 
    };
  };
}
