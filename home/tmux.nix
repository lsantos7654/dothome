{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    prefix = "C-Space";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];

    extraConfig = ''
      # Window navigation
      bind -n M-H previous-window
      bind -n M-L next-window

      # Pane settings
      set -g pane-base-index 1
      set -g allow-passthrough on
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # Terminal features for true color
      set-option -a terminal-features 'xterm-256color:RGB'

      # Clipboard settings (Wayland)
      set-option -g set-clipboard off
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"

      # Toggle status bar
      bind-key b set-option status

      # Alt+number window switching
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Window/pane management
      bind-key r command-prompt -I "#W" "rename-window '%%'"
      bind-key x kill-pane
      bind-key X kill-window

      # Splits (open in current path)
      bind h split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"

      # Swap panes
      bind-key j swap-pane -D
      bind-key k swap-pane -U

      # Swap windows
      bind-key H swap-window -t -1\; select-window -t -1
      bind-key L swap-window -t +1\; select-window -t +1

      # Move window to position
      bind-key M-1 swap-window -t 1
      bind-key M-2 swap-window -t 2
      bind-key M-3 swap-window -t 3
      bind-key M-4 swap-window -t 4
      bind-key M-5 swap-window -t 5
      bind-key M-6 swap-window -t 6
      bind-key M-7 swap-window -t 7
      bind-key M-8 swap-window -t 8
      bind-key M-9 swap-window -t 9

      # Join pane
      bind u command-prompt -p "join-pane to window:" "join-pane -h -t %%"

      # Minimal status bar styling
      set -g status-style "bg=default,fg=white"
      set -g status-left ""
      set -g status-right "#[fg=brightblack]#S"
      set -g status-justify centre
      set -g window-status-format "#[fg=brightblack] #I #W "
      set -g window-status-current-format "#[fg=white,bold] #I #W "
      set -g status-position bottom
    '';
  };
}
