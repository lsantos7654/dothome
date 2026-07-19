{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user.name = "Lucas Santos";
    settings.user.email = "lsantos7654@gmail.com";
    extraConfig.credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
  };
}
