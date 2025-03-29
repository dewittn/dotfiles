{ pkgs, lib, config, ... }: {

  options = {
    programmingPkgsModule.enable = lib.mkEnableOption "enables programmingPkgsModule";
  };

  config = lib.mkIf config.programmingPkgsModule.enable {
    environment.systemPackages = with pkgs;
      [
        _1password-cli
        docker
        gh
        git
        ollama
        linode-cli
        lmstudio
      ];
  };

}