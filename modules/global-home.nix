{
  home-manager = {
    useGlobalPkgs = true;
    users.mercury = ../home.nix;
    backupFileExtension = ".bak";
  };

}
