from spotify_control.common import get_spotify_client


def main():
    sp = get_spotify_client()
    sp.previous_track()
    print("Went to previous song.")


if __name__ == "__main__":
    main()
