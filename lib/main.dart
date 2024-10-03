/* Author: N-BOIS Developer Team*/
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nbois_user_client/env/env.dart';
import 'package:nbois_user_client/screen/countdown.dart';
import 'package:nbois_user_client/screen/map.dart';
import 'package:nbois_user_client/screen/notification.dart';

Future<void> main() async {
  // supabaseの初期化
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.SupabaseUrl, anonKey: Env.SupabaseAnonKey);
  // 縦向き固定
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N-BOIS',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansJavaneseTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.blueGrey,
      ),
      // dark modeを有効化
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansJavaneseTextTheme(
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
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  late final StreamSubscription<List<ConnectivityResult>>
      connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ネットワーク接続状況の監視
  @override
  void initState() {
    super.initState();
    initConnectivity();

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus.contains(ConnectivityResult.none)) {
      return const Scaffold(
        body: Center(
          child: Text('インターネット接続がありません'),
        ),
      );
    } else {
      // 時刻表の取得
      getTimetable();

      return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.map), label: '地図'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.lock_clock), label: '時刻表'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: 'お知らせ'),
            ],
            type: BottomNavigationBarType.fixed,
          ));
    }
  }
}
