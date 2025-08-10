{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wleave # has nicer images that wlogout
  ];
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        keybind = "r";
      }
    ];

    style = ''    
      * {
    background-image: none;
    font-size: 14px;
}


window {
    background-color: transparent;
}

button {
    color:  #ebdbb2;
    background-color: #1d2021;
    background-repeat: no-repeat;
    background-position: center;
    background-size: 25%;
    box-shadow: none;
    text-shadow: none;
    animation: gradient_f 20s ease-in infinite;
    margin: 20px;
    border-radius: 15px;    
}


button:hover {
    background-color: #1d2021;
    background-size: 50%;
    border-radius: 10px;
    animation: gradient_f 20s ease-in infinite;
    transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
}

button:hover#lock {
    border-radius: 10px;
    margin : 10px 0px 10px 10px;
}

button:hover#logout {
    border-radius: 10px;
    margin : 10px 0px 10px 0px;
}


button:hover#shutdown {
    border-radius: 10px;
    margin : 10px 0px 10px 0px;
}


button:hover#reboot {
    border-radius: 10px;
    margin : 10px 10px 10px 0px;
}

      #lock {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/lock.svg")); 
      }

      #logout {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/logout.svg"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/shutdown.svg"));
      }

      #reboot {
        background-image: image(url("${pkgs.wleave}/share/wleave/icons/reboot.svg"));
      }
          
    '';

  };
}