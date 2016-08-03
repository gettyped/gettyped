with import <nixpkgs> {};
with haskellPackages;

buildPythonPackage { 
  name = "projEnv";
  buildInputs = [
     stdenv
     stack
  ];
  src = null;
  # When used as `nix-shell -- pure`
  shellHook = ''
  unset http_proxy
  PATH="./node_modules/.bin/:$PATH"
  '';
  # used when building environments
  extraCmds = ''
  unset http_proxy # otherwise downloads will fail ("nodtd.invalid")
  '';
}
