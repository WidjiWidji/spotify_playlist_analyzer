//import 'dart:html';

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as image;
import 'package:spotify/spotify.dart';
import 'dart:io';
import 'dart:convert';
//import 'package:pie_chart/pie_chart.dart';
import 'package:genresortify/widgets/centered_view/centered_view.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:genresortify/assets/colors/colors.dart';
import 'package:genresortify/spotifyApi/id/secret.dart';
import 'package:genresortify/spotifyApi/services/get_methods.dart';
import 'package:genresortify/widgets/chart/radar_chart/radar_chart.dart';

var features;
var track;
SpotifyApiCredentials credentials =
    SpotifyApiCredentials(client_id, client_secret);
SpotifyApi spotify = SpotifyApi(credentials);

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var playlist;
  var features;
  late Future<List<RawDataSet>> dataSet;
  late Future<Playlist> playlistInfo;
  late Pages<Track> playlistTracks;
  late Future<Iterable<Track>> trackIterable;
  late Future<List<Track>> trackList;
  @override
  void initState() {
    //track = getTrack(spotify);
    //print(track);
    //print(features);
    dataSet = getAudioFeaturesDataSet(spotify);
    playlistInfo = getPlaylist(spotify);
    playlistTracks = getPlaylistTracks(spotify);
    trackIterable = playlistTracks.all();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spotifyBackgroundColor,
      body: SingleChildScrollView(
        child: CenteredView(
          child: SafeArea(
            child: Column(
              children: [
                Text(
                  'Spotify Playlist Analyzer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                FutureBuilder<Playlist>(
                  future: playlistInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Playlist? playlistSnap = snapshot.data;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Currently Analyzing: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Container(
                                height: 100,
                                child: Row(
                                  children: [
                                    Text(
                                      '${playlistSnap!.name}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    image.Image.network(
                                        '${playlistSnap.images!.first.url}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'made by: ${playlistSnap.owner!.displayName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(
                            width: 25,
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 1000,
                  height: 500,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        width: 500,
                        height: 500,
                        child: AspectRatio(
                          aspectRatio: 1.2,
                          child: FutureBuilder<List<RawDataSet>>(
                            future: dataSet,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<RawDataSet>? data = snapshot.data;
                                return AudioFeaturesChart(
                                  spotify: spotify,
                                  chartData: data,
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: DraggableScrollableSheet(
                          builder: (BuildContext scrollContext,
                              ScrollController scrollController) {
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: FutureBuilder<Iterable<Track>>(
                                future: trackIterable,
                                builder: (context, snapshot) {
                                  Iterable<Track>? trackIterable =
                                      snapshot.data;
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      controller: scrollController,
                                      itemCount: trackIterable!.length,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Container(
                                          height: 50,
                                          width: 300,
                                          color: spotifyBackgroundColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${i + 1}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                //image.Image.network('$ trackIterable.elementAt(i).}'),
                                                Container(
                                                  width: 300,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child: Text(
                                                      '${trackIterable.elementAt(i).name}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 10,
                                                    ),
                                                    child: Text(
                                                      '${trackIterable.elementAt(i).artists!.first.name}',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                //image.Image.network('$ trackIterable.elementAt(i).}')
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
