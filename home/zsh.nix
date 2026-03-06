{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "fzf" ];
    };

    initExtraFirst = ''
      # p10k instant prompt (must be at very top of .zshrc)
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';

    initExtra = ''
        # Environment
        export EDITOR=nvim
        export PATH=$HOME/.local/bin:$PATH
        export PATH="$PATH:$HOME/.luarocks/bin"
        export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$HOME/.luarocks/share/lua/5.1/?/init.lua;$LUA_PATH"
        export LUA_CPATH="$HOME/.luarocks/lib/lua/5.1/?.so;$LUA_CPATH"

        # ── Docker Functions ───────────────────────────────────────────
        function color_echo {
          echo -e "''${1}''${2}''${NC}"
        }

        export YELLOW='\033[0;33m'
        export RED='\033[0;31m'
        export BROWN='\033[0;33m'
        export BLUE='\033[0;34m'
        export GREEN='\033[0;32m'
        export GRAY='\033[0;37m'
        export CYAN='\033[0;36m'
        export LYELLOW='\033[1;33m'
        export LRED='\033[1;31m'
        export LBLUE='\033[1;34m'
        export LGREEN='\033[1;32m'
        export LGRAY='\033[1;37m'
        export LCYAN='\033[1;36m'
        export NC='\033[0m'
        export BOLD='\033[1;0m'
        export NORMAL='\033[0;0m'

        function dls {
          color_echo "$LBLUE" "Active docker containers:"
          docker container ls
          echo -e ""
          color_echo "$LYELLOW" "Stopped docker containers:"
          docker ps --filter "status=exited"
        }

        function dzsh {
          if [ "$#" -ne 1 ]; then
            echo -e "Usage: dsh <container>"
          else
            if ! drunning $1; then
              docker restart $1
            fi
            docker -it --user $USER $1 /usr/bin/zsh
          fi
        }

        function drunning {
          if [[ "$(docker container inspect -f '{{.State.Status}}' $1)" == "running" ]]; then
            return 0
          else
            return 1
          fi
        }

        function dim {
          color_echo "$LGRAY" "List of docker images:"
          docker images
        }

        function dkill {
          if [ "$#" -ne 1 ]; then
            echo -e "Usage: dkill <container>"
          else
            if drunning $1; then
              docker kill $1
            else
              echo -e "Container $1 is not running."
            fi
          fi
        }

        function drm {
          if [ "$#" -ne 1 ]; then
            echo -e "Usage: drm <container>"
          else
            docker rm $1
          fi
        }

        function dcommit {
          if [ "$#" -ne 2 ]; then
            echo -e "Usage: dcommit <container> <image_name>"
          else
            if ! drunning $1; then
              docker commit $1 $2
            else
              echo -e "Unable to commit. The container $1 is still running. Stop it first."
            fi
          fi
        }

        # ── Completions ──────────────────────────────────────────────────
        # Docker
        function _docker_all() {
          reply=($(docker ps -a --format '{{.Names}}'))
        }
        function _docker_on() {
          reply=($(docker ps --format '{{.Names}}'))
        }
        compctl -K _docker_all drm
        compctl -K _docker_on dkill
        compctl -K _docker_all drunning
        compctl -K _docker_all dzsh

        # Jupyter
        function _kernel_completions() {
          reply=($(jupyter kernelspec list | grep -v "Available" | awk '{print $1}'))
        }
        compctl -K _kernel_completions start_kernel
        compctl -K _kernel_completions delete_kernel

        # Gcloud
        _gcloud_completions() {
          local curcontext="$curcontext" state line
          typeset -A opt_args
          _arguments -C \
            "1:instances:($(gcloud compute instances list --format='value(name)'))" \
            "2:zones:($(gcloud compute zones list --format='value(name)'))" \
            "3:files:_files"
        }
        compdef _gcloud_completions gcloud_start
        compdef _gcloud_completions gcloud_stop
        compdef _gcloud_completions gcloud_enter
        compdef _gcloud_completions gcloud_copy

        # ── Functions ────────────────────────────────────────────────────
        function fuzzycd() {
          local file=$(find . -type f | fzf --query="$1" +m)
          if [ -n "$file" ]; then
            cd "$(dirname "$file")" || return
          fi
        }

        function bat_tail() {
          local lines=''${1:-10}
          local file
          if [[ -f $1 ]]; then
            file=$1
            lines=10
          else
            file=$2
          fi
          bat --line-range $(expr $(wc -l < "$file") - $lines): "$file"
        }

        function pwd_with_file() {
          current_dir=$(pwd)
          current_file=$(basename "$1")
          echo "''${current_dir}/''${current_file}"
        }

        function create_kernel() {
          if [ -z "$1" ]; then
            echo "Please specify a kernel name"
            return 1
          fi
          python -m ipykernel install --user --name=$1
        }

        function start_kernel() {
          jupyter kernel --kernel=$1
        }

        function delete_kernel() {
          if [ -z "$1" ]; then
            echo "Please specify a kernel to delete"
            return 1
          fi
          jupyter kernelspec uninstall "$1" -f
        }

        function open_nvim() {
          nvim .
        }
        zle -N open_nvim

        function clear_screen() {
          clear
          zle reset-prompt
        }
        zle -N clear_screen

        function follow_link() {
          builtin cd "$(dirname "$(readlink -f "$1")")"
        }

        function gcloud_start() {
          gcloud compute instances start $1 --zone $2
        }

        function gcloud_stop() {
          gcloud compute instances stop $1 --zone $2
        }

        function gcloud_copy() {
          local full_path
          full_path=$(realpath "$3")
          local base_name
          base_name=$(basename "$3")
          gcloud compute scp --recurse "$full_path" "$1:~/$base_name" --zone="$2"
        }

        function gcloud_enter() {
          gcloud compute ssh $1 --ssh-flag="-X" --ssh-flag="-L 8085:localhost:8085" --zone=$2
        }

        function docker_script() {
          local input_dir=$(realpath "$1")
          local output_dir=$(realpath "$2")
          local image="$3"
          docker run --rm -d -v "$input_dir:/input" -v "$output_dir:/output" "$image"
        }
        _docker_script_completions() {
          local curcontext="$curcontext" state line
          typeset -A opt_args
          _arguments -C \
            "1:files:_files" \
            "2:files:_files" \
            "3:images:($(docker images --format "{{.Repository}}:{{.Tag}}"))"
        }
        compdef _docker_script_completions docker_script

        # ── Keybindings ──────────────────────────────────────────────────
        bindkey '^n' open_nvim
        bindkey "^p" clear_screen
        bindkey "^[h" backward-word
        bindkey "^[l" vi-forward-word-end

        # ── Zoxide ───────────────────────────────────────────────────────
        eval "$(zoxide init --cmd cd zsh)"

        # ── Powerlevel10k ───────────────────────────────────────────────
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # ── Hivemind ─────────────────────────────────────────────────────
        _hivemind_completion() {
          eval $(env _TYPER_COMPLETE_ARGS="''${words[1,$CURRENT]}" _HIVEMIND_COMPLETE=complete_zsh hivemind)
        }

        compdef _hivemind_completion hivemind
    '';

    shellAliases = {
      # Editor
      v = "nvim";

      # Listing (eza)
      l = "eza -lh --icons=auto";
      ls = "eza -1 --icons=auto";
      la = "eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "eza -lhD --icons=auto";
      lt = "tree -h --du ./";
      ll = "eza -lha --icons=auto";

      # Git
      g = "git";
      lg = "lazygit";
      gpull = "git stash && git pull && git stash pop";

      # Tmux
      tls = "tmux ls";
      tkill = "tmux kill-session -t ";

      # Docker
      dscript = "docker_script";

      # Gcloud
      gstart = "gcloud_start";
      gstop = "gcloud_stop";
      gzsh = "gcloud_enter";
      gcp = "gcloud_copy";
      gls = "gcloud compute instances list";

      # Jupyter
      kls = "jupyter kernelspec list";
      kstart = "start_kernel";
      knew = "create_kernel";
      krm = "delete_kernel";

      # Misc
      watch = "watch ";
      python = "python3";
      pip = "uv pip";
      bat = "bat --paging=never";
      re = "glow README.md";
      cpr = "rsync --recursive --progress";
      ipa = "ip -c a";
      fcd = "fuzzycd";
      cdl = "follow_link";
      pwf = "pwd_with_file";
      wlt = "watch tree -h --du ./";
      wlta = "watch tree -h --du -a ./";
      ".." = "cd ..";
    };
  };

  # Powerlevel10k config (symlinked so `p10k configure` can edit in-place)
  home.file.".p10k.zsh".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dothome/config/p10k.zsh";
}
