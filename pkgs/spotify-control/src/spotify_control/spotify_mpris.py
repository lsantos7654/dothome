
import time
import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib
from spotify_control.common import get_spotify_client

class SpotifyMPRIS(dbus.service.Object):
    def __init__(self):
        bus_name = dbus.service.BusName('org.mpris.MediaPlayer2.spotify', dbus.SessionBus())
        dbus.service.Object.__init__(self, bus_name, '/org/mpris/MediaPlayer2')
        self.sp = get_spotify_client()

    @dbus.service.method('org.mpris.MediaPlayer2.Player')
    def PlayPause(self):
        current_playback = self.sp.current_playback()
        if current_playback is not None and current_playback['is_playing']:
            self.sp.pause_playback()
        else:
            self.sp.start_playback()

    @dbus.service.method('org.mpris.MediaPlayer2.Player')
    def Next(self):
        self.sp.next_track()

    @dbus.service.method('org.mpris.MediaPlayer2.Player')
    def Previous(self):
        self.sp.previous_track()

    @dbus.service.method(dbus.PROPERTIES_IFACE, in_signature='ss', out_signature='v')
    def Get(self, interface_name, property_name):
        return self.GetAll(interface_name)[property_name]

    @dbus.service.method(dbus.PROPERTIES_IFACE, in_signature='s', out_signature='a{sv}')
    def GetAll(self, interface_name):
        if interface_name == 'org.mpris.MediaPlayer2.Player':
            current_track = self.sp.current_user_playing_track()
            if current_track:
                return {
                    'Metadata': dbus.Dictionary({
                        'xesam:title': current_track['item']['name'],
                        'xesam:artist': [artist['name'] for artist in current_track['item']['artists']],
                        'xesam:album': current_track['item']['album']['name'],
                    }, signature='sv')
                }
        return {}

    @dbus.service.method(dbus.PROPERTIES_IFACE, in_signature='ssv')
    def Set(self, interface_name, property_name, new_value):
        pass

    @dbus.service.signal(dbus.PROPERTIES_IFACE, signature='sa{sv}as')
    def PropertiesChanged(self, interface_name, changed_properties, invalidated_properties):
        pass

def update_properties(mpris):
    mpris.PropertiesChanged('org.mpris.MediaPlayer2.Player', 
                            mpris.GetAll('org.mpris.MediaPlayer2.Player'), [])
    return True

def main():
    DBusGMainLoop(set_as_default=True)
    mpris = SpotifyMPRIS()
    loop = GLib.MainLoop()
    GLib.timeout_add_seconds(5, update_properties, mpris)
    loop.run()

if __name__ == '__main__':
    main()
