with import <nixpkgs> {};
stdenv.mkDerivation {
name = "env";
buildInputs = [caddy emacs gist git nodejs sbt];
shellHook = ''
  export PATH="$PATH:./node_modules/.bin"
  npm install
'';
}
