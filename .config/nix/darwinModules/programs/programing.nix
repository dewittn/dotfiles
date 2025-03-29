{ pkgs, lib, config, ... }: {

  options = {
    programmingModule.enable = lib.mkEnableOption "enables baseModule";
  };

  config = lib.mkIf config.programmingModule.enable {
    environment.systemPackages = with pkgs;
      [
        _1password-cli
        docker
        gh
        git
        linode-cli
      ];
  };

}