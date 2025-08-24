{ pkgs, ... }:

let
  # Python interpreter with 'requests' included to avoid packaging hassles
  pyWithRequests = pkgs.python3.withPackages (p: [ p.requests ]);

  # ---- btop launcher/focuser (Waybar click) ----
  btopScript = pkgs.writeShellApplication {
    name = "btop-waybar";
    runtimeInputs = with pkgs; [ hyprland jq kitty btop ];
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail
      TITLE="btop-waybar"
      # Find the window with the matching title
      client_id=$(hyprctl clients -j | jq -r ".[] | select(.title == \"$TITLE\") | .address")
      if [[ -n "$client_id" && "$client_id" != "null" ]]; then
        # Focus the window using its address
        hyprctl dispatch focuswindow address:"$client_id"
      else
        # Launch a new terminal with the desired title
        kitty --title "$TITLE" -e btop &
      fi
    '';
  };

  # ---- weather script (Python) launched via a Bash here-doc ----
  # Using a here-doc avoids Nix multi-line string terminator issues caused by Python ''.
  getWeatherScript = pkgs.writeShellApplication {
    name = "get-weather";
    runtimeInputs = [ pyWithRequests ];
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail
      exec ${pyWithRequests}/bin/python - <<'PY'
import os
import json
import requests
from datetime import datetime

# Ensure robust UTF-8 I/O
os.environ.setdefault("PYTHONIOENCODING", "UTF-8")

# --- Configuration ---
LOCATION = "Biratnagar, Nepal"
TEMP_UNIT = os.getenv("WEATHER_TEMPERATURE_UNIT", "c").lower()
TIME_FORMAT = os.getenv("WEATHER_TIME_FORMAT", "12h").lower()
WINDSPEED_UNIT = os.getenv("WEATHER_WINDSPEED_UNIT", "km/h").lower()
SHOW_ICON = os.getenv("WEATHER_SHOW_ICON", "True").lower() in ("true", "1", "t", "y", "yes")
SHOW_LOCATION = os.getenv("WEATHER_SHOW_LOCATION", "False").lower() in ("true", "1", "t", "y", "yes")
SHOW_TODAY_DETAILS = os.getenv("WEATHER_SHOW_TODAY_DETAILS", "True").lower() in ("true", "1", "t", "y", "yes")
FORECAST_DAYS = int(os.getenv("WEATHER_FORECAST_DAYS", "3"))

WEATHER_CODES = {
    "113": "", "116": "", "119": "", "122": "", "143": "",
    "248": "", "260": "", "176": "", "179": "", "182": "",
    "185": "", "263": "", "266": "", "281": "", "284": "",
    "293": "", "296": "", "299": "", "302": "", "305": "",
    "308": "", "311": "", "314": "", "317": "", "350": "",
    "353": "", "356": "", "359": "", "362": "", "365": "",
    "368": "", "392": "", "200": "", "227": "", "230": "",
    "320": "", "323": "", "326": "", "374": "", "377": "",
    "386": "", "389": "", "329": "", "332": "", "335": "",
    "338": "", "371": "", "395": "",
}

def get_weather_data(location):
    try:
        url = f"https://wttr.in/{location}?format=j1"
        headers = {"User-Agent": "Mozilla/5.0"}
        r = requests.get(url, timeout=10, headers=headers)
        r.raise_for_status()
        return r.json()
    except (requests.exceptions.RequestException, json.JSONDecodeError) as e:
        return {"error": str(e)}

def format_temperature(c, f):
    return f"{c}°C" if TEMP_UNIT == "c" else f"{f}°F"

def format_wind_speed(kmph, mph):
    return f"{kmph}Km/h" if WINDSPEED_UNIT == "km/h" else f"{mph}Mph"

def _fmt_to_12h(hhmm):  # "HH:MM" -> "h:MM AM/PM"
    return datetime.strptime(hhmm, "%H:%M").strftime("%I:%M %p").lstrip("0")

def _fmt_to_24h(s):
    for fmt in ("%H:%M", "%I:%M %p"):
        try:
            return datetime.strptime(s, fmt).strftime("%H:%M")
        except ValueError:
            pass
    return s

def format_time(s):
    if TIME_FORMAT == "24h":
        return _fmt_to_24h(s)
    try:
        datetime.strptime(s, "%I:%M %p")
        return s
    except ValueError:
        try:
            return _fmt_to_12h(s)
        except ValueError:
            return s

def main():
    weather = get_weather_data(LOCATION)
    if "error" in weather:
        print(json.dumps({"text": "⚠️", "tooltip": weather["error"]}))
        return

    cur = weather["current_condition"][0]
    today = weather["weather"][0]

    # Avoid escaped empty-string inside f-string expressions
    code_now = str(cur.get("weatherCode") or "")
    text = format_temperature(cur["temp_C"], cur["temp_F"])
    if SHOW_ICON:
        text = f"{WEATHER_CODES.get(code_now, '❓')} {text}"

    if SHOW_LOCATION:
        loc = weather["nearest_area"][0]["areaName"][0]["value"]
        country = weather["nearest_area"][0]["country"][0]["value"]
        text += f" | {loc}, {country}"

    tooltip = ""
    if SHOW_TODAY_DETAILS:
        loc = weather["nearest_area"][0]["areaName"][0]["value"]
        country = weather["nearest_area"][0]["country"][0]["value"]
        feels_like = format_temperature(cur["FeelsLikeC"], cur["FeelsLikeF"])
        wind = format_wind_speed(cur["windspeedKmph"], cur["windspeedMiles"])
        sunrise = format_time(today["astronomy"][0]["sunrise"])
        sunset  = format_time(today["astronomy"][0]["sunset"])
        desc = cur["weatherDesc"][0]["value"]

        tooltip += f"<b>{desc} {text}</b>\n"
        tooltip += f"Feels like: {feels_like}\n"
        tooltip += f"Location: {loc}, {country}\n"
        tooltip += f"Wind: {wind}\n"
        tooltip += f"Humidity: {cur['humidity']}%\n"
        tooltip += f" {sunrise}  {sunset}\n"

    from datetime import datetime as _dt
    now_h = _dt.now().hour

    for i in range(FORECAST_DAYS):
        day = weather["weather"][i]
        name = "Today" if i == 0 else ("Tomorrow" if i == 1 else day["date"])
        tmax = format_temperature(day["maxtempC"], day["maxtempF"])
        tmin = format_temperature(day["mintempC"], day["mintempF"])
        tooltip += f"\n<b>{name}</b>\n"
        tooltip += f"⬆️ {tmax} ⬇️ {tmin}\n"

        for hour in day["hourly"]:
            t = int(hour["time"])  # "0","300","600",...
            hh, mm = t // 100, t % 100
            if i == 0 and hh < now_h:
                continue
            hhmm = f"{hh:02d}:{mm:02d}"
            htime = format_time(hhmm)
            htemp = format_temperature(hour["tempC"], hour["tempF"])
            code_hour = str(hour.get("weatherCode") or "")
            icon = WEATHER_CODES.get(code_hour, "❓")
            desc = hour["weatherDesc"][0]["value"]
            tooltip += f"{htime} {icon} {htemp} {desc}\n"

    print(json.dumps({"text": text, "tooltip": tooltip.strip()}))

if __name__ == "__main__":
    main()
PY
    '';
  };
in
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "group/center-group" ];
        modules-right = [ "group/right-group" "tray" "custom/logout" ];

        "group/center-group" = {
          orientation = "horizontal";
          modules = [ "clock"  "idle_inhibitor" ];
        };

        "group/right-group" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio"
            "network"
            "backlight"
            "power-profiles-daemon"
            "battery"
          ];
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [ "" ];
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          on-click = "gnome-calendar";
        };

        cpu = {
          format = " {usage}%";
          tooltip = true;
          interval = 1;
          on-click = "${btopScript}/bin/btop-waybar";
        };

        disk = {
          format = " {free}";
          interval = 30;
          path = "/";
        };

        "hyprland/window" = {
          format = "{class}:{title}";
          max-length = 20;
          separate-outputs = true;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "custom/logout" = {
          format = "󰍃";
          tooltip = false;
          on-click = "wlogout -b 2";
        };

        memory = {
          format = " {used:0.1f}G";
          interval = 1;
          on-click = "${btopScript}/bin/btop-waybar";
        };

        mpris = {
          format = "{player_icon} {title}";
          format-paused = "{status_icon} <i>{title}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
          max-length = 50;
          "on-click-prev" = "playerctl previous";
          "on-click-play" = "playerctl play-pause";
          "on-click-next" = "playerctl next";
        };

        network = {
          "format-wifi" = " ";
          "format-ethernet" = " {ifname}";
          "format-disconnected" = "⚠ Disconnected";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "on-click" = "nm-connection-editor";
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          "format-icons" = {
            default = "";
            performance = "";
            balanced = "";
            "power-saver" = "";
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          "format-muted" = "";
          "format-icons" = {
            headphone = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" ];
          };
          on-click = "pavucontrol";
        };

        tray = {
          "icon-size" = 18;
          spacing = 10;
        };

        "custom/weather" = {
          exec = "${getWeatherScript}/bin/get-weather";
          tooltip = true;
          format = "{0}";
          interval = 120;          # friendlier to wttr.in; adjust as you like
          "return-type" = "json";
        };
      };
    };

    style = ''
      * {
          border: none;
          font-family: "FiraCode Nerd Font";
          font-size: 14px;
          min-height: 0;
      }
      window#waybar {
          background-color: rgba(40, 40, 40, 0.85);
          color: #ebdbb2;
          transition-property: background-color;
          transition-duration: .5s;
          border-radius: 15px;
          padding: 0 10px;
      }
      #workspaces button {
          padding: 0 10px;
          background-color: transparent;
          color: #ebdbb2;
          border-radius: 10px;
          margin: 5px 0;
      }
      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }
      #workspaces button.focused {
          background-color: #83a598;
          color: #282828;
      }
      #workspaces button.urgent {
          background-color: #fb4934;
      }
      #workspaces button.active {
          background-color: #ebdbb2;
          color: #282828;
      }
      #window {
          padding: 0 15px;
          margin: 0 10px;
      }
      /* --- Group Styling --- */
      #group-center-group,
      #group-right-group {
          margin: 5px 3px;
          background-color: transparent;
      }
      #group-center-group *,
      #group-right-group * {
          padding: 0 15px;
          color: #ebdbb2;
          background-color: transparent;
          border-radius: 0;
      }
      /* Round the ends of the pills */
      #clock {
          border-top-left-radius: 10px;
          border-bottom-left-radius: 10px;
          margin: 0 10px;
      }
      #custom-weather {
          margin: 0 10px;
      }
      #bluetooth {
          margin: 0 10px;
      }
      #mpris {
          margin: 0 10px;
      }
      #idle_inhibitor{
          border-top-right-radius: 10px;
          border-bottom-right-radius: 10px;
          margin: 0 10px;
      }
      #pulseaudio {
          border-top-left-radius: 10px;
          border-bottom-left-radius: 10px;
          margin: 0 10px;
      }
      #memory {
          margin: 0 10px;
      }
      #power-profiles-daemon {
          margin: 0 10px;
      }
      #cpu {
          margin: 0 10px;
      }
      #disk {
          margin: 0 10px;
      }
      #network {
          margin: 0 10px;
      }
      #custom-logout,
      #backlight {
          margin: 0 10px;
      }
      #battery {
          border-top-right-radius: 10px;
          border-bottom-right-radius: 10px;
          margin: 0 10px;
      }
      #tray {
          background-color: transparent;
          padding: 0 10px;
          margin: 5px 3px;
          border-radius: 10px;
      }
      #custom-power {
          background-color: #fb4934;
          color: #282828;
          padding: 0 10px;
          margin: 5px 3px;
          border-radius: 10px;
      }
      tooltip {
          background-color: rgba(40, 40, 40,0.95);
          color: #ebdbb2;
          border-radius: 10px;
          border: 2px solid #83a598;
          padding: 10px;
      }
      tooltip label {
          color: #ebdbb2;
      }
    '';
  };
}

