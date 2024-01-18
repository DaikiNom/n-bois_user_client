import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nbois_user_client/screen/settings.dart';

class BusMap extends StatefulWidget {
  const BusMap({Key? key}) : super(key: key);

  @override
  _BusMapState createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  // 位置情報のアップデートをlisten
  late final Stream<List<BusLocation>> _busLocationStream;
  final client = Supabase.instance.client;

  final _markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    _busLocationStream = client
        .from('bus_location')
        .stream(primaryKey: ['busId']).map((maps) => maps
            .map((map) => BusLocation.fromMap(
                  map: map,
                  id: map['busId'],
                ))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // 設定画面へ遷移
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Settings()));
          },
          icon: const Icon(Icons.settings),
        ),
        title: const Text('N-BOIS'),
      ),
      body: StreamBuilder<List<BusLocation>>(
        stream: _busLocationStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('エラーが発生しました'));
          } else if (snapshot.hasData) {
            _markers.clear();
            for (final busLocation in snapshot.data!) {
              if (busLocation.latitude <= 90 &&
                  busLocation.latitude >= -90 &&
                  busLocation.longitude <= 180 &&
                  busLocation.longitude >= -180) {
                _markers.add(
                  Marker(
                    key: ValueKey<String>(busLocation.id),
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(busLocation.latitude, busLocation.longitude),
                    child: const Icon(
                      Icons.directions_bus_filled,
                      color: Colors.green,
                    ),
                  ),
                );
              }
            }
            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(35.851997, 140.011988),
                initialZoom: 14,
              ),
              children: [
                // cancelable tile providerを使う
                TileLayer(
                  urlTemplate:
                      'https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png',
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                MarkerLayer(markers: _markers),
                // クレジット
                RichAttributionWidget(
                  animationConfig: const FadeRAWA(),
                  attributions: [
                    TextSourceAttribution('地理院タイル',
                        onTap: () => launchUrl(Uri.parse(
                            'https://maps.gsi.go.jp/development/ichiran.html'))),
                    const TextSourceAttribution(
                        'Shoreline data is derived from:\r\n United States.National Imagery and Mapping Agency.\r\n"Vector Map Level 0 (VMAP0)." Bethesda, MD: Denver, CO: The Agency;\r\n USGS Information Services, 1997.',
                        prependCopyright: false),
                  ],
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class BusLocation {
  final latitude;
  final longitude;
  final String id;

  BusLocation.fromMap({
    required Map<String, dynamic> map,
    required this.id,
  })  : latitude = map['latitude'],
        longitude = map['longitude'];
}

class BusDetail {
  final String id;
  final String destination;
  final List? via;
  final TimeOfDay departureTime;

  BusDetail.fromMap({
    required Map<String, dynamic> map,
    required this.id,
  })  : destination = map['destination'],
        via = map['via'],
        // departureTimeはString型で保存されているのでTimeOfDay型に変換
        departureTime = TimeOfDay(
          hour: int.parse(map['departureTime'].toString().substring(0, 2)),
          minute: int.parse(map['departureTime'].toString().substring(3, 5)),
        );
}
