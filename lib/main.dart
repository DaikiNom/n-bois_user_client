import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

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
        // フォントを指定
        textTheme: GoogleFonts.kleeOneTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      // ホーム画面を指定
      home: const BusApp(),
    );
  }
}

class BusApp extends StatefulWidget {
  const BusApp({Key? key}) : super(key: key);

  @override
  _BusAppState createState() => _BusAppState();
}

class _BusAppState extends State<BusApp> {
  Text busDetail(BusSchedule busSchedule) {
    if (busSchedule.id == -1) {
      // timerはいらない
      dispose();
      return const Text(
        '本日の運行は終了しました',
        style: TextStyle(fontSize: 30),
        textAlign: TextAlign.center,
      );
    } else if (busSchedule.id == 2) {
      return const Text(
        '柏行き(教職員優先)',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        '次の ${busSchedule.destination}行き のバスまで',
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.right,
      );
    }
  }

  // カウントダウン用
  late StreamSubscription<dynamic> _subscription;
  String _countdownText = '';

  @override
  void initState() {
    super.initState();

    // カウントダウン用
    _subscription = Stream.periodic(const Duration(seconds: 1)).listen((event) {
      // 現在の時刻を取得
      final now = DateTime.now();

      // 次のバスの発車時刻を取得
      final nextBus = getFirstBus();

      // 残り時間を計算
      final remainingTime = DateTime(now.year, now.month, now.day,
              nextBus.departureTime.hour, nextBus.departureTime.minute)
          .difference(now);

      // カウントダウンテキストを更新
      setState(() {
        _countdownText =
            '${remainingTime.inMinutes}分${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}秒';
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // カウントダウン用
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バス時刻表'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            busDetail(getFirstBus()),
            Text(
              _countdownText,
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BusSchedule {
  final int id;
  final String destination;
  final TimeOfDay departureTime;

  BusSchedule(this.id, this.destination, this.departureTime);
}

// 一番はやく出発するバスを取得する
BusSchedule getFirstBus() {
  List<BusSchedule> busSchedules = [
    // 柏行きのみでテスト
    // id [-1 → 本日の運行は終了しました, 1 → 柏行き, 2 → 柏行き(教職員優先)]
    // id, destination, departureTime(TimeOfDay)
    BusSchedule(1, '柏', const TimeOfDay(hour: 11, minute: 10)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 11, minute: 50)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 12, minute: 10)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 12, minute: 50)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 13, minute: 30)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 13, minute: 50)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 14, minute: 20)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 15, minute: 10)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 15, minute: 40)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 16, minute: 10)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 16, minute: 40)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 16, minute: 55)),
    BusSchedule(2, '柏', const TimeOfDay(hour: 17, minute: 10)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 17, minute: 30)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 17, minute: 45)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 18, minute: 00)),
    BusSchedule(2, '柏', const TimeOfDay(hour: 18, minute: 20)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 18, minute: 45)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 19, minute: 00)),
    BusSchedule(1, '柏', const TimeOfDay(hour: 19, minute: 20)),
  ];
  // 今の時刻を取得
  final now = DateTime.now();
  // 一番はやく出発するバスを取得
  final firstBus = busSchedules.firstWhereOrNull((busSchedule) => DateTime(
          now.year,
          now.month,
          now.day,
          busSchedule.departureTime.hour,
          busSchedule.departureTime.minute)
      .isAfter(now));

  // 存在しない場合の処理
  if (firstBus == null) {
    return BusSchedule(-1, '本日の運行は終了しました', const TimeOfDay(hour: 0, minute: 0));
  } else {
    return firstBus;
  }
}
