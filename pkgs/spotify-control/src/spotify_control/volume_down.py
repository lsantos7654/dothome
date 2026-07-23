from spotify_control.common import get_spotify_client


def main():
    sp = get_spotify_client()
    current_volume = sp.current_playback()["device"]["volume_percent"]
    new_volume = max(current_volume - 10, 0)
    sp.volume(new_volume)
    print(f"Volume decreased to {new_volume}%")


if __name__ == "__main__":
    main()
