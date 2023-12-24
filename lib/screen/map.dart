import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(busLocation.latitude, busLocation.longitude),
                    child: const Icon(
                      Icons.directions_bus,
                      color: Colors.blue,
                    ),
                  ),
                );
              }
            }
            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(35.851997, 140.011988),
                initialZoom: 12.5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: _markers,
                ),
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
