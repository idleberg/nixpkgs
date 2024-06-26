{ lib
, stdenv
, testers
, fetchFromGitHub
, rustPlatform
, darwin
, numbat
}:

rustPlatform.buildRustPackage rec {
  pname = "numbat";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "numbat";
    rev = "v${version}";
    hash = "sha256-/jt1+21yem0q/dlc7z89MRaVrnllb9QLSQUo2f/9q8o=";
  };

  cargoHash = "sha256-8AA0LTw/9kd6yDme4N3/ANVkS67eoLrJviNhdqUftXM=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env.NUMBAT_SYSTEM_MODULE_PATH = "${placeholder "out"}/share/${pname}/modules";

  postInstall = ''
    mkdir -p $out/share/${pname}
    cp -r $src/${pname}/modules $out/share/${pname}/
  '';

  passthru.tests.version = testers.testVersion {
    package = numbat;
  };

  meta = with lib; {
    description = "High precision scientific calculator with full support for physical units";
    longDescription = ''
      A statically typed programming language for scientific computations
      with first class support for physical dimensions and units
    '';
    homepage = "https://numbat.dev";
    changelog = "https://github.com/sharkdp/numbat/releases/tag/v${version}";
    license = with licenses; [ asl20 mit ];
    mainProgram = "numbat";
    maintainers = with maintainers; [ giomf atemu ];
  };
}
