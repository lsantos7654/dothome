import os

import spotipy
from dotenv import load_dotenv
from spotipy.oauth2 import SpotifyOAuth


def get_spotify_client():
    # Load environment variables from .env file
    env_path = os.path.join(os.getenv("HOME"), ".spotify", ".env")
    load_dotenv(env_path)

    # Add user-library-modify scope
    scope = "user-read-playback-state user-modify-playback-state user-library-modify"

    token_cache_path = os.path.join(
        os.getenv("HOME"), ".spotify", "spotify_token-cache"
    )
    os.makedirs(os.path.dirname(token_cache_path), exist_ok=True)

    return spotipy.Spotify(
        auth_manager=SpotifyOAuth(scope=scope, cache_path=token_cache_path)
    )
