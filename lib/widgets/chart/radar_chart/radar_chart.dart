import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:genresortify/assets/colors/colors.dart';
import 'package:spotify/spotify.dart';
import 'package:genresortify/spotifyApi/services/get_methods.dart';

class AudioFeaturesChart extends StatelessWidget {
  final SpotifyApi spotify;
  final List<RawDataSet>? chartData;

  const AudioFeaturesChart({
    Key? key,
    required this.spotify,
    this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: showingDataSets(spotify, chartData),
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
        gridBorderData: const BorderSide(color: Colors.white, width: 2),
      ),
      swapAnimationDuration: Duration(milliseconds: 150), // Optional
      swapAnimationCurve: Curves.linear, //Optional
    );
  }
}

Future<List<RawDataSet>> getAudioFeaturesDataSet(SpotifyApi spotify) async {
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
  Playlist playlistName = await getPlaylist(spotify);
  Pages<Track> tracks = getPlaylistTracks(spotify);
  Iterable<Track> tracksIt = await tracks.all();
  Iterable<String> trackIds = [
    '0fea68AdmYNygeTGI4RC18',
    '2TH65lNHgvLxCKXM3apjxI',
    '4MzXwWMhyBbmu6hOcLVD49',
    '1Ej96GIBCTvgH7tNX1r3qr',
    '7mWFF4gPADjTQjC97CgFVt',
    '0GzuHFG4Ql6DoyxFRnIk3F',
    '7rwX0O3RlxqqIjQM8evm5E',
    '4R8BJggjosTswLxtkw8V7P',
    '7MmrcXVA7A5zZ2CbDuGHNa',
    '4nbWX2HzrOEnX4xxvYRCyU',
    '4CLkDJ4xLqkV4Vt2vPOny1',
    '2L95U6syP0bV3fkYYOzmiW',
    '0KkIkfsLEJbrcIhYsCL7L5',
    '3GVhFY1hAKPW5TiWM2TnpV',
    '25ZAibhr3bdlMCLmubZDVt',
  ];
  print('playlist image: ${playlistName.images!.length}');
  print(
      'Getting tracks from playlist: ${playlistName.name} made by ${playlistName.owner!.displayName}');
  print('Follower: ${playlistName.followers!.total}');

  List<String?> preTrackIds = [];
  int i = 0;
  for (Track track in tracksIt) {
    if (i < 99) {
      preTrackIds.add(track.id);
      print('song: ${track.name}: ${track.id}');
    } else {
      break;
    }
  }
  /*
  for (int i = 0; i < 50; i++) {
    preTrackIds.add(tracksIt.elementAt(i).id);
    print('song: ${tracksIt.elementAt(i).name}: ${tracksIt.elementAt(i).id}');
  }
  */

  for (var id in preTrackIds) {
    i++;
    print("'$id',");
  }
  //trackIds = preTrackIds as Iterable<String>;
  print('${trackIds.length}');

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

  List<RawDataSet> chartData = [
    RawDataSet(
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
    ),
  ];
  return chartData;
}

List<RadarDataSet> showingDataSets(
    SpotifyApi spotify, List<RawDataSet>? chartData) {
  List<RawDataSet> list = chartData!;
  List<RawDataSet> res = list; //need to fix how do we go from Future to List
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
