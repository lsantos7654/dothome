{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Lucas Santos";
      user.email = "lsantos7654@gmail.com";
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };
}
