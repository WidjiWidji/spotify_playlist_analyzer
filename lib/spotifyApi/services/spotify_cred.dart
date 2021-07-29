import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

Future<SpotifyApi> getSpotifyCredential() async {
  /*
  var keyJson =
      await File('https://api.spotify.com/v1/me/playlists').readAsString();
  var keyMap = json.decode(keyJson);
  */
  const client_id = '801aa1de8e3443338881043e37428bb4';
  const client_secret = '774cec35b8914a8991a3e0847eddb695';

  //var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
  var credentials = SpotifyApiCredentials(client_id, client_secret);
  var spotify = SpotifyApi(credentials);
  return spotify;
}
