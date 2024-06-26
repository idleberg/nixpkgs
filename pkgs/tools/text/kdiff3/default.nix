{ stdenv
, lib
, fetchurl
, extra-cmake-modules
, kdoctools
, wrapQtAppsHook
, boost
, kcrash
, kconfig
, kinit
, kparts
, kiconthemes
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kdiff3";
  version = "1.10.7";

  src = fetchurl {
    url = "mirror://kde/stable/kdiff3/kdiff3-${finalAttrs.version}.tar.xz";
    hash = "sha256-uj9Ky/SsdIrr78hfWcr2U9Rf6FmkjDSviZGCJKdnxeM=";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapQtAppsHook ];

  buildInputs = [ boost kconfig kcrash kinit kparts kiconthemes ];

  cmakeFlags = [ "-Wno-dev" ];

  meta = with lib; {
    description = "Compares and merges 2 or 3 files or directories";
    homepage = "https://invent.kde.org/sdk/kdiff3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
})
