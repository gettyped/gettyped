with import <nixpkgs> {};
stdenv.mkDerivation {
name = "env";
buildInputs = [caddy gnutar gzip emacs gist git nodejs sbt zip];
shellHook = ''
  export PATH="$PATH:./node_modules/.bin"
  npm install
'';
}
