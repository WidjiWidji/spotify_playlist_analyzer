import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

final String playlistId = '1W0J3fvuOJruipKBWDrikb';
Future<Playlist> getPlaylist(SpotifyApi spotify) async {
  var playlist = await spotify.playlists.get(playlistId);
  return playlist;
}

Pages<Track> getPlaylistTracks(SpotifyApi spotify) {
  var tracks = spotify.playlists.getTracksByPlaylistId(playlistId);
  return tracks;
}

Future<Track> getTrack(SpotifyApi spotify) async {
  var track = await spotify.tracks.get('1AROE0XcC4ySCxXF65mutZ');
  return track;
}

Future<List<String?>> addTrackIdsFromPlaylist(SpotifyApi spotify) async {
  Pages<Track> playlist = getPlaylistTracks(spotify);
  Iterable<Track> tracksIt = await playlist.all();
  List<String?> trackIds = [];
  for (Track track in tracksIt) {
    trackIds.add(track.id);
  }
  return trackIds;
}

Future<Iterable<Track>> getTrackIterable(SpotifyApi spotify) async {
  return getPlaylistTracks(spotify).all();
}

/*
Future<List<String?>> getImageUrls(int index, SpotifyApi spotify) async {
  List<String?> trackIds = await addTrackIdsFromPlaylist(spotify);
  List<String?> imageUrls = [];
  for(String? id in trackIds){
    imageUrls.add('${trackIds.}')
  }
}
*/
