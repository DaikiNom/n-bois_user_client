import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/* 時刻表のList
  id, destination, departureTime(TimeOfDay)
  id: [1 → 常時運行, 2 → 常時運行(平日のみ教職員優先), 3 → 平日のみ運行, 4 → 休日のみ運行,-1 → 本日の運行は終了しました]
  departureTime: 出発時刻
*/
// NOTE: 時刻表は本番環境ではデータベース or API から取得するようにする

List<BusSchedule> forKashiwa = [
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

List<BusSchedule> forShinkamagaya = [
  BusSchedule(4, '西白井・白井・新鎌ケ谷', const TimeOfDay(hour: 13, minute: 15)),
  BusSchedule(3, '西白井・白井・新鎌ケ谷', const TimeOfDay(hour: 16, minute: 00)),
  BusSchedule(1, '西白井・白井・新鎌ケ谷', const TimeOfDay(hour: 18, minute: 30)),
];

List<BusSchedule> forHokuso = [
  BusSchedule(4, '北総', const TimeOfDay(hour: 13, minute: 15)),
  BusSchedule(3, '北総', const TimeOfDay(hour: 16, minute: 00)),
  BusSchedule(1, '北総', const TimeOfDay(hour: 18, minute: 30)),
];

class BusCountdown extends StatefulWidget {
  const BusCountdown({Key? key}) : super(key: key);

  @override
  _BusCountdownState createState() => _BusCountdownState();
}

class _BusCountdownState extends State<BusCountdown> {
  String busDetail(BusSchedule busSchedule) {
    if (busSchedule.id == -1) {
      return '本日の運行は終了しました';
    } else if (busSchedule.id == 2) {
      return '次の ${busSchedule.destination}(教職員優先) のバスまで';
    } else {
      return '次の ${busSchedule.destination}行き のバスまで';
    }
  }

  // カウントダウン用
  late StreamSubscription<dynamic> _subscription;
  String _countdownTextForKashiwa = '',
      _countdownTextForShinkamagaya = '',
      _countdownTextForforHokuso = '';

  @override
  void initState() {
    super.initState();

    // カウントダウン用
    _subscription = Stream.periodic(const Duration(seconds: 1)).listen((event) {
      // 現在の時刻を取得
      final now = DateTime.now();

      // 3つの時刻表についてそれぞれ一番はやく出発するバスを取得
      final firstBusForKashiwa = getFirstBus(forKashiwa);
      // 柏行きのバスが出発するまでの時間を取得
      final timeForKashiwa = DateTime(
              now.year,
              now.month,
              now.day,
              firstBusForKashiwa.departureTime.hour,
              firstBusForKashiwa.departureTime.minute)
          .difference(now);

      final firstBusForShinkamagaya = getFirstBus(forShinkamagaya);
      // 新鎌ケ谷行きのバスが出発するまでの時間を取得
      final timeForShinkamagaya = DateTime(
              now.year,
              now.month,
              now.day,
              firstBusForShinkamagaya.departureTime.hour,
              firstBusForShinkamagaya.departureTime.minute)
          .difference(now);

      final firstBusForforHokuso = getFirstBus(forHokuso);
      // 北総行きのバスが出発するまでの時間を取得
      final timeForforHokuso = DateTime(
              now.year,
              now.month,
              now.day,
              firstBusForforHokuso.departureTime.hour,
              firstBusForforHokuso.departureTime.minute)
          .difference(now);

      // countdowntextを更新
      setState(() {
        // 最終便の時刻を過ぎていたら何も表示しない
        if (firstBusForKashiwa.id == -1) {
          _countdownTextForKashiwa = '🔚';
        } else {
          _countdownTextForKashiwa =
              '${timeForKashiwa.inMinutes}分${(timeForKashiwa.inSeconds % 60).toString().padLeft(2, '0')}秒';
        }

        if (firstBusForShinkamagaya.id == -1) {
          _countdownTextForShinkamagaya = '🔚';
        } else {
          _countdownTextForShinkamagaya =
              '${timeForShinkamagaya.inMinutes}分${(timeForShinkamagaya.inSeconds % 60).toString().padLeft(2, '0')}秒';
        }

        if (firstBusForforHokuso.id == -1) {
          _countdownTextForforHokuso = '🔚';
        } else {
          _countdownTextForforHokuso =
              '${timeForforHokuso.inMinutes}分${(timeForforHokuso.inSeconds % 60).toString().padLeft(2, '0')}秒';
        }
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
    final screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('バス時刻表'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '校舎発'),
              Tab(text: '校舎行'),
            ],
          ),
        ),
        body: ScreenUtilInit(
          designSize: const Size(1080, 1920),
          splitScreenMode: true,
          // 画面サイズに応じて文字サイズを調整
          builder: (context, screenUtil) {
            return TabBarView(
              // 校舎発・校舎行きでTabbar, 行き先・出発駅ごとにその中で縦並びにして表示
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 柏行き
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            busDetail(getFirstBus(forKashiwa)),
                            style: TextStyle(
                                fontSize: screenWidth > 830 ? 25.sp : 45.sp),
                          ),
                          Text(
                            _countdownTextForKashiwa,
                            style: TextStyle(
                                fontSize: screenWidth > 830 ? 50.sp : 90.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                    Divider(
                        height: 30.w,
                        thickness: 3,
                        color: const Color.fromARGB(255, 150, 200, 233)),
                    // 新鎌ケ谷行き
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            busDetail(getFirstBus(forShinkamagaya)),
                            style: TextStyle(
                                fontSize: screenWidth > 830 ? 25.sp : 45.sp),
                          ),
                          Text(
                            _countdownTextForShinkamagaya,
                            style: TextStyle(
                                fontSize: screenWidth > 830 ? 50.sp : 90.sp,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                    Divider(
                        height: 30.w,
                        thickness: 3,
                        color: const Color.fromARGB(255, 168, 211, 233)),
                    // 北総行き
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            busDetail(getFirstBus(forHokuso)),
                            style: TextStyle(
                                fontSize: screenWidth > 830 ? 25.sp : 45.sp),
                          ),
                          Text(
                            _countdownTextForforHokuso,
                            style: TextStyle(
                                fontSize: screenWidth > 830 ? 50.sp : 90.sp,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                  ],
                ),
                // 校舎行き
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        busDetail(getFirstBus(forKashiwa)),
                        style: TextStyle(
                            fontSize: screenWidth > 830 ? 30.sp : 50.sp),
                      ),
                    ])
              ],
            );
          },
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
BusSchedule getFirstBus(List<BusSchedule> busSchedules) {
  // 今の時刻を取得
  final now = DateTime.now(); //NOTE: もしここが直指定されていた場合，ミスなので.now()に変更しておいて
  // 一番はやく出発するバスを取得
  final firstBus;

  if (now.weekday == DateTime.sunday || now.hour <= 5) {
    // 日曜日 or まだ5時前の場合
    firstBus = null;
  } else if (now.weekday == DateTime.saturday) {
    // 土曜日の場合
    firstBus = busSchedules
        .where((busSchedule) =>
            busSchedule.id == 4 || busSchedule.id == 1 || busSchedule.id == 2)
        .firstWhereOrNull((busSchedule) => DateTime(
                now.year,
                now.month,
                now.day,
                busSchedule.departureTime.hour,
                busSchedule.departureTime.minute)
            .isAfter(now));
  } else {
    // 平日の場合
    firstBus = busSchedules
        .where((busSchedule) =>
            busSchedule.id == 3 || busSchedule.id == 1 || busSchedule.id == 2)
        .firstWhereOrNull((busSchedule) => DateTime(
                now.year,
                now.month,
                now.day,
                busSchedule.departureTime.hour,
                busSchedule.departureTime.minute)
            .isAfter(now));
  }

  // firstBusに何も格納されていない場合の処理
  if (firstBus == null) {
    return BusSchedule(-1, '本日の運行は終了しました', const TimeOfDay(hour: 0, minute: 0));
  } else {
    return firstBus;
  }
}
