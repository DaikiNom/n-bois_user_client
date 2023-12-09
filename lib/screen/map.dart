import 'package:flutter/material.dart';

class BusMap extends StatefulWidget {
  const BusMap({Key? key}) : super(key: key);

  @override
  _BusMapState createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('N-BOIS'),
      ),
      body: const Center(
        child: Text('BusMap'),
      ),
    );
  }
}
