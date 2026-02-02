{ config, lib, ... }:
{
  options = {
    hasLocalEmacs = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
