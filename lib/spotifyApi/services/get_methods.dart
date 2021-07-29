import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

Future<dynamic> getPlaylist(SpotifyApi spotify) async {
  var playlist = await spotify.playlists.get('3kVWMkkBzhQ1EN6rFwtYxO');

  return playlist;
}

Future<dynamic> getTrack(SpotifyApi spotify) async {
  var track = await spotify.tracks.get('1AROE0XcC4ySCxXF65mutZ');
  print('\ntrack name = ${track.name}');
  return track;
}
