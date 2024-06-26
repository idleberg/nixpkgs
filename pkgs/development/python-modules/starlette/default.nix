{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, hatchling

# dependencies
, anyio
, typing-extensions

# optional dependencies
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, httpx

# tests
, pytestCheckHook
, pythonOlder
, trio

# reverse dependencies
, fastapi
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.35.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ynT1KowVJ1QdKLSOXYWVe5Q/PrYEWQDUbj395ebfk6Y=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    anyio
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  passthru.optional-dependencies.full = [
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    httpx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
    typing-extensions
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  pythonImportsCheck = [
    "starlette"
  ];

  passthru.tests = {
    inherit fastapi;
  };

  meta = with lib; {
    changelog = "https://github.com/encode/starlette/releases/tag/${version}";
    downloadPage = "https://github.com/encode/starlette";
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
