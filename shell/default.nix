{ lib, rustPlatform, fontconfig, freetype, libxkbcommon, pkg-config }:

rustPlatform.buildRustPackage {
  pname = "nyx-shell";
  version = "0.1.0";
  src = ./.;
  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fontconfig freetype libxkbcommon ];

  meta = with lib; {
    description = "Wayland shell for Nyx: top bar, app launcher, and panels";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "nyx-shell";
  };
}
