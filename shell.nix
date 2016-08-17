with import <nixpkgs> {};
stdenv.mkDerivation {
name = "env";
buildInputs = [emacs gist git];
}
