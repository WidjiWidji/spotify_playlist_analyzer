//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'dart:io';
import 'dart:convert';
//import 'package:pie_chart/pie_chart.dart';
import 'package:genresortify/widgets/centered_view/centered_view.dart';
import 'package:fl_chart/fl_chart.dart';

const spotifyGreenColor = Color(0xff1BD760);
const spotifyBackgroundColor = Color(0xff181818);
const client_id = '801aa1de8e3443338881043e37428bb4';
const client_secret = '774cec35b8914a8991a3e0847eddb695';
SpotifyApi spotify = SpotifyApi(credentials);

var features;
var track;
SpotifyApiCredentials credentials =
    SpotifyApiCredentials(client_id, client_secret);

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var playlist;
  var features;

  @override
  void initState() {
    track = getTrack(spotify);
    print(track);
    print(features);

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
              child: FutureBuilder(
                future: getAudioFeaturesDataSet(spotify),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RadarChart(
                      RadarChartData(
                        dataSets: showingDataSets(),
                        radarBackgroundColor: Colors.transparent,
                        borderData: FlBorderData(show: true),
                        radarBorderData: const BorderSide(
                          style: BorderStyle.solid,
                          color: Colors.white,
                        ),
                        titlePositionPercentageOffset: 0.2,
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        getTitle: (index) {
                          switch (index) {
                            case 0:
                              return 'Danceability';
                            case 1:
                              return 'Energy';
                            case 2:
                              return 'Speechiness';
                            case 3:
                              return 'Acousticness';
                            case 4:
                              return 'Instrumentalness';
                            case 5:
                              return 'Liveness';
                            case 6:
                              return 'Valence';
                            default:
                              return '';
                          }
                        },
                        tickBorderData: const BorderSide(color: Colors.white),
                        gridBorderData:
                            const BorderSide(color: Colors.white, width: 2),
                      ),
                      swapAnimationDuration:
                          Duration(milliseconds: 150), // Optional
                      swapAnimationCurve: Curves.linear, //Optional
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

Future<dynamic> getPlaylist(SpotifyApi spotify) async {
  var playlist = await spotify.playlists.get('3kVWMkkBzhQ1EN6rFwtYxO');

  return playlist;
}

Future<dynamic> getTrack(SpotifyApi spotify) async {
  var track = await spotify.tracks.get('1AROE0XcC4ySCxXF65mutZ');
  print('\ntrack name = ${track.name}');
  return track;
}

Future<RawDataSet> getAudioFeaturesDataSet(SpotifyApi spotify) async {
  double danceSum = 0,
      energySum = 0,
      speechSum = 0,
      acousticSum = 0,
      instrumentSum = 0,
      valenceSum = 0,
      liveSum = 0;
  double danceAvg,
      energyAvg,
      speechAvg,
      acousticAvg,
      instrumentAvg,
      valenceAvg,
      liveAvg;
  Iterable<String> trackIds = [
    '1AROE0XcC4ySCxXF65mutZ',
    '5k5fWendNngd89O8JKoE8L',
    '1AROE0XcC4ySCxXF65mutZ'
  ];
  Iterable<AudioFeature> features = await spotify.audioFeatures.list(trackIds);
  for (var i in features) {
    danceSum += i.danceability!;
    energySum += i.energy!;
    speechSum += i.speechiness!;
    acousticSum += i.speechiness!;
    instrumentSum += i.instrumentalness!;
    valenceSum += i.valence!;
    liveSum += i.liveness!;
  }
  double size = features.length.toDouble();
  print(size);
  danceAvg = danceSum / size;
  energyAvg = energySum / size;
  speechAvg = speechSum / size;
  acousticAvg = acousticSum / size;
  instrumentAvg = instrumentSum / size;
  valenceAvg = valenceSum / size;
  liveAvg = liveSum / size;

  return RawDataSet(
    title: 'Song Audio Features',
    color: spotifyGreenColor,
    values: [
      danceAvg,
      energyAvg,
      speechAvg,
      acousticAvg,
      instrumentAvg,
      valenceAvg,
      liveAvg
    ],
  );
}

List<RadarDataSet> showingDataSets() {
  List<RawDataSet> res = getAudioFeaturesDataSet(spotify) as List<RawDataSet>;
  return res.asMap().entries.map((entry) {
    var index = entry.key;
    var rawDataSet = entry.value;

    final isSelected = index == selectedDataSetIndex
        ? true
        : selectedDataSetIndex == -1
            ? true
            : false;
    return RadarDataSet(
      fillColor: isSelected
          ? rawDataSet.color.withOpacity(0.4)
          : rawDataSet.color.withOpacity(0.25),
      borderColor:
          isSelected ? rawDataSet.color : rawDataSet.color.withOpacity(0.25),
      entryRadius: isSelected ? 3 : 2,
      dataEntries: rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
      borderWidth: isSelected ? 2.3 : 2,
    );
  }).toList();
}

int selectedDataSetIndex = -1;

List<RawDataSet> rawDataSets() {
  return [
    RawDataSet(
      title: 'Song Audio Features',
      color: spotifyGreenColor,
      values: [
        0.557, //Danceability
        0.719, //Energy
        0.0372, //Speechiness
        0.00267, //Acousticness
        0, //Instrumentalness
        0.306, //Liveness
        0.344, //Valence
      ],
    ),
  ];
}

class RawDataSet {
  final String title;
  final Color color;
  final List<double> values;

  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });
}
