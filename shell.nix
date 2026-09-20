{
  rev ? "d6c71932130818840fc8fe9509cf50be8c64634f",
  pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  }) { config = {}; overlays = []; },
  ...
}:
pkgs.mkShell {
  packages = [
    pkgs.uv
    pkgs.pkg-config
    pkgs.ninja
    pkgs.cairo
    (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
      pyserial
      pycairo
      pillow
      ninja
    ]))
  ];
  shellHook = ''
    echo '
    # Phomemo Label Printer Shell

    $ sudo bluetoothctl devices  # <-- to discover the device

      Device 00:4B:12:A3:0C:DA airlytix-es1-a30cd8
      Device 80:99:E7:56:D0:8B WH-1000XM5
      Device A7:45:EE:2F:5E:E8 P12 Label Printer  # <--

    $ sudo rfcomm  connect 1 A7:45:EE:2F:5E:E8 &  # <-- to conecct to it (replace MAC address)

      Connected /dev/rfcomm1 to A7:45:EE:2F:5E:E8 on channel
      Press CTRL-C for hangup

    # will give you a device like /dev/rfcomm1 to use in the next step:
    '

    echo '$ python phomemo/render_label.py  "Misc. Werkzeug" |
      sudo python phomemo/print_p12.py  --port=/dev/rfcomm1
    '

    echo "# There's an alias for that: phom <text> [<size>]"

    echo; echo "# Good sizes are: 96, 48, 32, 22"

    phom() {
      python src/phomemo-p12-tools/render_label.py --font-size "''${2:-88}" "''${1:?need text as first argument}" |
        sudo python src/phomemo-p12-tools/rint_p12.py --port=/dev/rfcomm1
    }
    export -f phom
    '';
}
