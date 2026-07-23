from spotify_control.common import get_spotify_client


def main():
    sp = get_spotify_client()

    # Get currently playing track
    current_playback = sp.current_playback()

    if current_playback is None or current_playback.get("item") is None:
        print("No song is currently playing.")
        return

    track = current_playback["item"]
    track_id = track["id"]
    track_name = track["name"]
    artist_names = ", ".join([artist["name"] for artist in track["artists"]])

    try:
        # Add track to user's library (like it)
        sp.current_user_saved_tracks_add([track_id])
        print(f"Liked: {track_name} by {artist_names}")
    except Exception as e:
        print(f"Failed to like song: {e}")


if __name__ == "__main__":
    main()
