{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}@args:
with lib.nuko;
mkModule args
  [
    "desktop"
    "hyprland"
  ]
  {
    nuko = {
      desktop = {
        waybar = enabled;
      };
      services = {
        swayidle = enabled;
      };
    };

    programs = {
      fuzzel = {
        enable = true;
        settings.main = {
          lines = 6;
          line-height = 32;
          width = 24;
          terminal = "${pkgs.foot}/bin/footclient";
        };
      };

      # TODO swaylock-effects screenshot disapears after DPMS.
      swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          grace = 30;
          daemonize = true;
          screenshots = true;
          clock = true;
          indicator = true;

          effect-blur = "7x5";
          fade-in = 0.2;

          # ring-color = "bb00cc";
        };
      };
    };

    services = {
      swww = {
        enable = true;
        systemdTarget = "hyprland-session.target";
        startupWallpaper = osConfig.nuko.theme.wallpaper.path;
      };
    };

    home.packages = with pkgs; [
      gnome.adwaita-icon-theme
      polkit_gnome
      qt6.qtwayland
      qt5.qtwayland
      playerctl
      swaynotificationcenter
      swayosd
      #onagre # Broken pkg. https://github.com/NixOS/nixpkgs/pull/235072
    ];

    services.swayosd.enable = true;

    wayland.windowManager.hyprland =
      let
        swayosd = "${pkgs.swayosd}/bin/swayosd";
      in
      {
        enable = true;
        systemd.enable = true;
        extraConfig = ''
          monitor = DP-2,1920x1080@144,0x100,1
          monitor = DP-1,2560x1440@170,1920x0,1

          # Start polkit agent
          exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
          exec-once = waybar
          exec-once = ${pkgs.swaynotificationcenter}/bin/swaync

          # Move all steam proton games to workspace 3 and enable tearing.
          windowrulev2 = workspace 3, class:^(steam_app_)(.*)$
          windowrulev2 = immediate, class:^(steam_app_)(.*)$

          windowrulev2 = workspace 3, class:StaTech Industry
          windowrulev2 = immediate, class:StaTech Industry


          # MPV PIP
          windowrulev2 = opacity 0.7, class:mpv
          windowrulev2 = opaque, class:mpv
          windowrulev2 = noblur, class:mpv


          # Source a file (multi-file configs)
          # source = ~/.config/hypr/myColors.conf

          # Some default env vars.
          env = XCURSOR_SIZE,24

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input {
              kb_layout = us
              follow_mouse = 1
              # sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
              accel_profile = flat
          }

          general {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more

              gaps_in = 5
              gaps_out = 10
              border_size = 2
              col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
              col.inactive_border = rgba(595959aa)

              layout = dwindle
              allow_tearing = true
          }
          # Required for tearing, and also fixes AMD driver vrr cursor bug.
          env = WLR_DRM_NO_ATOMIC,1

          misc {
              vrr = 1
              no_direct_scanout = false
          }

          decoration {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more

              rounding = 10

              blur {
                  enabled = true
                  size = 4
                  passes = 2
              }

              active_opacity = 0.965
              inactive_opacity = 0.965

              drop_shadow = true
              shadow_range = 4
              shadow_render_power = 3
              col.shadow = rgba(1a1a1aee)
          }

          animations {
              enabled = true

              # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

              bezier = myBezier, 0.05, 0.9, 0.1, 1.05

              animation = windows, 1, 7, myBezier
              animation = windowsOut, 1, 7, default, popin 80%
              animation = border, 1, 10, default
              animation = borderangle, 1, 8, default
              animation = fade, 1, 7, default
              animation = workspaces, 1, 6, default
          }

          dwindle {
              no_gaps_when_only = 1
              # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
              pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = true # you probably want this
          }

          master {
              # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
              new_is_master = true
          }

          gestures {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              workspace_swipe = false
          }

          # Example windowrule v1
          # windowrule = float, ^(kitty)$
          # Example windowrule v2
          # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


          # See https://wiki.hyprland.org/Configuring/Keywords/ for more
          $mainMod = SUPER

          # MPV PIP

          bind = $mainMod SHIFT, G, togglefloating,
          bind = $mainMod SHIFT, G, toggleopaque,
          bind = $mainMod SHIFT, G, pin,

          bind = $mainMod, O, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw
          bind = $mainMod, RETURN, exec, foot
          bind = $mainMod, Q, killactive,
          bind = $mainMod SHIFT, BACKSPACE, exit,
          bind = $mainMod, E, exec, nemo
          bind = $mainMod, G, togglefloating,
          bind = $mainMod, T, fullscreen,
          bind = $mainMod, F, exec, firefox --browser
          bind = $mainMod, D, exec, fuzzel
          bind = $mainMod, P, pseudo, # dwindle
          bind = $mainMod, J, togglesplit, # dwindle
          bind = $mainMod, R, togglegroup # dwindle
          bind = $mainMod, TAB, changegroupactive, f # dwindle
          bind = $mainMod SHIFT, TAB, changegroupactive, b   # dwindle

          bind = $mainMod, BRACKETRIGHT, movewindow, mon:2

          # Move focus with mainMod + arrow keysrr
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9
          bind = $mainMod, 0, workspace, 10

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9
          bind = $mainMod SHIFT, 0, movetoworkspace, 10


          bind = $mainMod SHIFT, L, exec, ${config.programs.swaylock.package}/bin/swaylock
          # Scroll through existing workspaces with mainMod + scroll
          bind = $mainMod, mouse_down, workspace, e+1
          bind = $mainMod, mouse_up, workspace, e-1

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow

          bindl=, XF86AudioRaiseVolume, exec, ${swayosd} --output-volume raise # wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
          bindl=, XF86AudioLowerVolume, exec, ${swayosd} --output-volume lower #  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          bindl=, XF86AudioPlay, exec, playerctl play-pause

          exec-once=xrandr --output DP-1 --primary
          exec-once=hyprctl dispatch workspace 1
          workspace=1,monitor:DP-1
          workspace=2,monitor:DP-2
          workspace=3,monitor:DP-1
          workspace=4,monitor:DP-2
          workspace=5,monitor:DP-1
          workspace=6,monitor:DP-2
          workspace=7,monitor:DP-1
          workspace=8,monitor:DP-2
          workspace=9,monitor:DP-1
          workspace=10,monitor:DP-2

          # Gtk application bug fix. Unsure if needed. Too lazy to test.
          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        '';
      };
  }
