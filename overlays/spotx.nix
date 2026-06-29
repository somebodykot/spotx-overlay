final: prev:
let
  old-pkgs = import (prev.fetchzip {
    url = "https://github.com/NixOS/nixpkgs/archive/release-23.05.tar.gz";
    hash = "sha256-mlUc62b7Mw+Rpuiy0kqov5JCfrvKqgHLYfTf221gerM=";  # ①
  }) { system = prev.system; };

  spotx = prev.fetchurl {
    url = "https://github.com/SpotX-Official/SpotX-Bash/raw/5e9b08f91e55c210bbc64715b4ad698186b3c06b/spotx.sh";
    hash = "sha256-mlUc62b7Mw+Rpuiy0kqov5JCfrvKqgHLYfTf221gerM=";
  };
in
{
  spotify = old-pkgs.spotify.overrideAttrs (old: {
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ (with prev; [ util-linux perl unzip zip curl ]);

    unpackPhase = ''
      ${old.unpackPhase}
      patchShebangs --build ${spotx}
    '';

    installPhase = ''
      bash ${spotx} -f -P "$out/share/spotify" -o on
      ${old.installPhase}
    '';
  });
}
