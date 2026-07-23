from setuptools import find_packages, setup

setup(
    name="spotify-control",
    version="0.1",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    install_requires=[
        "spotipy",
        "dbus-python",
        "PyGObject",
        "python-dotenv",
    ],
    entry_points={
        "console_scripts": [
            "spotify-next=spotify_control.next_song:main",
            "spotify-previous=spotify_control.previous_song:main",
            "spotify-play-pause=spotify_control.play_pause:main",
            "spotify-volume-up=spotify_control.volume_up:main",
            "spotify-volume-down=spotify_control.volume_down:main",
            "spotify-like=spotify_control.like_song:main",  # Add this line
            "spotify-mpris=spotify_control.spotify_mpris:main",
        ],
    },
)
