{ ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Lucas Santos";
      user.email = "lsantos7654@gmail.com";
    };
  };
}
