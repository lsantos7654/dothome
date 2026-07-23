from spotify_control.common import get_spotify_client


def main():
    sp = get_spotify_client()
    current_playback = sp.current_playback()
    if current_playback is not None and current_playback["is_playing"]:
        sp.pause_playback()
        print("Paused playback.")
    else:
        sp.start_playback()
        print("Started playback.")


if __name__ == "__main__":
    main()
