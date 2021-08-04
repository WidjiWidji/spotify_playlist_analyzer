//import 'dart:html';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    track = getTrack(spotify);
    print(track);
    print(features);
    dataSet = getAudioFeaturesDataSet(spotify);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: spotifyBackgroundColor,
      body: CenteredView(
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
            AspectRatio(
              aspectRatio: 1.8,
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
          ],
        ),
      ),
    );
  }
}
