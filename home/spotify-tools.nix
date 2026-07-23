{ pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ../pkgs/spotify-control { }) ];
}
