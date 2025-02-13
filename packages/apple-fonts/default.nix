{ lib, stdenv, fetchFromGitHub, }:
stdenv.mkDerivation {
  pname = "apple-fonts";
  version = "latest";

  # nix-prefetch-url --unpack https://github.com/haoxiangliew/apple-fonts/archive/master.tar.gz
  src = fetchFromGitHub {
    owner = "haoxiangliew";
    repo = "apple-fonts";
    rev = "master";
    sha256 = "1j6d4gs81z0qfn396bv5x4jl0rkawrcx5ydxwhsxrxgyzlsx6bm1";
  };

  installPhase = ''
    truetype_path=$out/share/fonts/truetype/apple-fonts
    mkdir -p $truetype_path

    opentype_path=$out/share/fonts/opentype/apple-fonts
    mkdir -p $opentype_path

    find -name "*.ttf" -exec mv {} $truetype_path \;
    find -name "*.otf" -exec mv {} $opentype_path \;
  '';

  meta = with lib; {
    description = "Fonts from Apple platforms";
    homepage = "https://developer.apple.com/fonts/";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ haoxiangliew ];
  };
}
