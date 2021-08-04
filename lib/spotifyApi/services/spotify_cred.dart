import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:genresortify/spotifyApi/id/secret.dart';

Future<SpotifyApi> getSpotifyCredential() async {
  /*
  var keyJson =
      await File('https://api.spotify.com/v1/me/playlists').readAsString();
  var keyMap = json.decode(keyJson);
  */

  //var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
  var credentials = SpotifyApiCredentials(client_id, client_secret);
  var spotify = SpotifyApi(credentials);
  return spotify;
}
