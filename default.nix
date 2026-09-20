# build with:
#    nix-build -E 'let pkgs = import <nixpkgs> { config={}; overlays=[]; }; in pkgs.python3Packages.callPackage ./default.nix {}'

{
  lib,
  buildPythonPackage,
  cairo,
  ninja,
  pkg-config,
  pyserial,
  pycairo,
  pillow,
  setuptools,
}:
buildPythonPackage {
  name = "phomemo-p12-tools";

  version = "0.0.5";

  pyproject = true;

  build-system = [ setuptools ];

  src = ./.;

  buildInputs = [
    cairo
    ninja
    pkg-config
  ];

  dependencies = [
    pyserial
    pycairo
    pillow
  ];

  doChecks = false;

  meta = with lib; {
    description = "Phomemo P12 Label Printing Tools";
    homepage = "https://github.com/soburi/phomemo_p12";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.confus ];
  };
}
