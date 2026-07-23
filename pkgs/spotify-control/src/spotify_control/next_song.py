from spotify_control.common import get_spotify_client


def main():
    sp = get_spotify_client()
    sp.next_track()
    print("Skipped to next song.")


if __name__ == "__main__":
    main()
