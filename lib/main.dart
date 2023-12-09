/* Author: N-BOIS Developer Team*/
// NOTE: このファイルで実装された機能は，将来的に他のファイルに移行する
// IDEA: マテリアルデザインではなく，ニューモーフィズムを採用する
// IDEA: ライセンス検討の上，ニューモーフィズム用のパッケージを導入する
// IDEA: 検討の上，taskbarに常駐させる←OS固有なので無理かも
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbois_user_client/screen/countdown.dart';
import 'package:nbois_user_client/screen/map.dart';
import 'package:nbois_user_client/screen/notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'バス時刻表',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: GoogleFonts.kleeOneTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.blueGrey,
      ),
      // dark modeを有効化
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.kleeOneTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
        primaryColor: Colors.blueGrey,
      ),
      themeMode: ThemeMode.system,
      // ホーム画面を指定
      home: const BusApp(),
    );
  }
}

// bottom navigation bar
class BusApp extends StatefulWidget {
  const BusApp({Key? key}) : super(key: key);

  @override
  _BusAppState createState() => _BusAppState();
}

class _BusAppState extends State<BusApp> {
  int _selectedIndex = 0;
  static const _screens = [
    BusMap(),
    BusCountdown(),
    NotificationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.map), label: '地図'),
            BottomNavigationBarItem(icon: Icon(Icons.lock_clock), label: '時刻表'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'お知らせ'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
