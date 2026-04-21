{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  package-groups = import ../packages.nix { inherit pkgs config inputs; };
in
{
  environment.systemPackages = [ pkgs.jupyter ];
  services.jupyter = {
    enable = true;
    password = "argon2:$argon2id$v=19$m=10240,t=10,p=8$g8/djGPI+0X3b8jcRpRdPA$hTelQSYqDh5LOB8kTEHeqUNrGFd5DPN36qWwCls/wBE";
    #notebookDir = "/home/mercury/projects/uni/comp20121/";
    extraPackages =
      with pkgs;
      [
        python313Packages.jupyterlab-vim
        python313Packages.nbconvert
        python313Packages.pypandoc
        haskellPackages.pandoc-cli
        pandoc
        texliveFull
      ]
      ++ package-groups.latex-docs;
    kernels = {
      python3 =
        let
          env = (
            pkgs.python3.withPackages (
              pythonPackages: with pythonPackages; [
                ipykernel
                pandas
                matplotlib
                scikit-learn
              ]
            )
          );
        in
        {
          displayName = "Python 3 for machine learning";
          argv = [
            "''${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
        };
    };
  };
}
