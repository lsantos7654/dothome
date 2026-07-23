{
  python3Packages,
  glib,
  gobject-introspection,
  wrapGAppsNoGuiHook,
}:

python3Packages.buildPythonApplication {
  pname = "spotify-control";
  version = "0.1";
  pyproject = true;

  src = ./.;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    spotipy
    dbus-python
    pygobject3
    python-dotenv
  ];

  # GI_TYPELIB_PATH wrapping so spotify-mpris can use gi.repository.GLib
  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsNoGuiHook
  ];
  buildInputs = [ glib ];
}
