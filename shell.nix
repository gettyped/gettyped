with import <nixpkgs> {};
stdenv.mkDerivation {
name = "env";
buildInputs = [caddy emacs gist git sbt];
}
