{ ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "Hack Nerd Font";
      size = 12;
    };
    settings = {
      hide_window_decorations = "titlebar-only";
      dynamic_background_opacity = "yes";
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      enable_audio_bell = "no";
      term = "xterm-256color";
      macos_option_as_alt = "both";
      confirm_os_window_close = 0;

      # Solarized Dark Higher Contrast
      background = "#001e26";
      foreground = "#9bc1c2";
      cursor = "#f34a00";
      selection_background = "#003747";
      selection_foreground = "#001e26";
      color0 = "#002731";
      color8 = "#006388";
      color1 = "#d01b24";
      color9 = "#f4153b";
      color2 = "#6bbe6c";
      color10 = "#50ee84";
      color3 = "#a57705";
      color11 = "#b17e28";
      color4 = "#2075c7";
      color12 = "#178dc7";
      color5 = "#c61b6e";
      color13 = "#e14d8e";
      color6 = "#259185";
      color14 = "#00b29e";
      color7 = "#e9e2cb";
      color15 = "#fcf4dc";
    };
  };
}
