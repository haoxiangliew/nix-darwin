{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gh-classroom";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-classroom";
    rev = "v${version}";
    sha256 = "0hhr6jskfjghydbm35qrv0api3kmpgzqlqbkpwdrajvs4m2zrvp0";
  };

  vendorHash = "sha256-UAGykOXXmdD/hMkeNHLYsIBX45TfobBVBXdSGE46t+4=";

  ldflags =
    [ "-s" "-w" "-X github.com/github/gh-classroom/cmd.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/github/gh-classroom";
    description = "gh extension for GitHub Classroom";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ haoxiangliew ];
    mainProgram = "gh-classroom";
  };
}
