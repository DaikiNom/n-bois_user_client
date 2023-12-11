import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/* 時刻表のList
  id, station, departureTime(TimeOfDay)
  id: [1 → 常時運行(校舎発), 2 → 常時運行(校舎行), 3 → 常時運行(平日のみ教職員優先), 4 → 平日のみ運行, 5 → 休日のみ運行, -1 → 本日の運行は終了しました]
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
  BusSchedule(3, '柏', const TimeOfDay(hour: 17, minute: 10)),
  BusSchedule(1, '柏', const TimeOfDay(hour: 17, minute: 30)),
  BusSchedule(1, '柏', const TimeOfDay(hour: 17, minute: 45)),
  BusSchedule(1, '柏', const TimeOfDay(hour: 18, minute: 00)),
  BusSchedule(3, '柏', const TimeOfDay(hour: 18, minute: 20)),
  BusSchedule(1, '柏', const TimeOfDay(hour: 18, minute: 45)),
  BusSchedule(1, '柏', const TimeOfDay(hour: 19, minute: 00)),
  BusSchedule(1, '柏', const TimeOfDay(hour: 19, minute: 20)),
];

List<BusSchedule> forShinkamagaya = [
  BusSchedule(5, '新鎌ケ谷方面', const TimeOfDay(hour: 13, minute: 15)),
  BusSchedule(4, '新鎌ケ谷方面', const TimeOfDay(hour: 16, minute: 00)),
  BusSchedule(1, '新鎌ケ谷方面', const TimeOfDay(hour: 18, minute: 30)),
];

List<BusSchedule> forHokuso = [
  BusSchedule(5, '北総方面', const TimeOfDay(hour: 13, minute: 15)),
  BusSchedule(4, '北総方面', const TimeOfDay(hour: 16, minute: 00)),
  BusSchedule(1, '北総方面', const TimeOfDay(hour: 18, minute: 30)),
];

List<BusSchedule> fromKashiwa = [
  BusSchedule(2, '柏', const TimeOfDay(hour: 7, minute: 10)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 7, minute: 15)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 7, minute: 20)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 7, minute: 25)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 7, minute: 35)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 7, minute: 40)),
  BusSchedule(2, '柏(二松駐車場)', const TimeOfDay(hour: 7, minute: 45)),
  BusSchedule(2, '柏(二松駐車場)', const TimeOfDay(hour: 8, minute: 05)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 8, minute: 27)),
  BusSchedule(2, '柏(二松駐車場)', const TimeOfDay(hour: 8, minute: 50)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 9, minute: 00)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 9, minute: 30)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 10, minute: 00)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 10, minute: 30)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 11, minute: 05)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 11, minute: 20)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 12, minute: 05)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 12, minute: 25)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 13, minute: 05)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 13, minute: 45)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 14, minute: 05)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 14, minute: 35)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 15, minute: 25)),
  BusSchedule(2, '柏', const TimeOfDay(hour: 15, minute: 55)),
];

List<BusSchedule> fromShinkamagaya = [
  BusSchedule(2, '新鎌ケ谷', const TimeOfDay(hour: 7, minute: 10)),
];

List<BusSchedule> fromShiroi = [
  BusSchedule(2, '白井', const TimeOfDay(hour: 7, minute: 15)),
  BusSchedule(2, '西白井', const TimeOfDay(hour: 7, minute: 25)),
];

List<BusSchedule> fromHokuso = [
  BusSchedule(2, '印旛日本医大', const TimeOfDay(hour: 7, minute: 10)),
  BusSchedule(2, '千葉ニュータウン', const TimeOfDay(hour: 7, minute: 15)),
  BusSchedule(2, '印西牧の原', const TimeOfDay(hour: 7, minute: 20)),
  BusSchedule(2, '小室', const TimeOfDay(hour: 7, minute: 30)),
];

List<BusSchedule> fromShinKashiwa = [
  BusSchedule(2, '新柏', const TimeOfDay(hour: 7, minute: 20)),
  BusSchedule(2, '新柏', const TimeOfDay(hour: 8, minute: 10)),
];

List<BusSchedule> fromAbiko = [
  BusSchedule(2, '我孫子', const TimeOfDay(hour: 7, minute: 20)),
  BusSchedule(2, '我孫子', const TimeOfDay(hour: 8, minute: 12)),
];

class BusCountdown extends StatefulWidget {
  const BusCountdown({Key? key}) : super(key: key);

  @override
  _BusCountdownState createState() => _BusCountdownState();
}

class _BusCountdownState extends State<BusCountdown> {
  String busDetailFromSchool(BusSchedule busSchedule) {
    if (busSchedule.id == -1) {
      return '本日の運行は終了しました';
    } else if (busSchedule.id == 2) {
      return '次の ${busSchedule.station}(教職員優先) のバスまで';
    } else {
      return '次の ${busSchedule.station}行き のバスまで';
    }
  }

  String busDetailToSchool(BusSchedule busSchedule) {
    if (busSchedule.id == -1) {
      return '本日の運行は終了しました';
    } else {
      return '次の ${busSchedule.station}発 のバスまで';
    }
  }

  // カウントダウン用
  late StreamSubscription<dynamic> _subscription;
  String _countdownTextForKashiwa = '',
      _countdownTextForShinkamagaya = '',
      _countdownTextForHokuso = '',
      _countdownTextFromKashiwa = '',
      _countdownTextFromShinkamagaya = '',
      _countdownTextFromShiroi = '',
      _countdownTextFromHokuso = '',
      _countdownTextFromShinKashiwa = '',
      _countdownTextFromAbiko = '';

  @override
  void initState() {
    super.initState();

    // カウントダウン用
    _subscription = Stream.periodic(const Duration(seconds: 1)).listen((event) {
      // 現在の時刻を取得
      final now = DateTime.now();

      // 3つの時刻表についてそれぞれ一番はやく出発するバスを取得
      final firstBusForKashiwa = getFirstBus(forKashiwa);
      final firstBusForShinkamagaya = getFirstBus(forShinkamagaya);
      final firstBusForHokuso = getFirstBus(forHokuso);
      final firstBusFromKashiwa = getFirstBus(fromKashiwa);
      final firstBusFromShinkamagaya = getFirstBus(fromShinkamagaya);
      final firstBusFromShiroi = getFirstBus(fromShiroi);
      final firstBusFromHokuso = getFirstBus(fromHokuso);
      final firstBusFromShinKashiwa = getFirstBus(fromShinKashiwa);
      final firstBusFromAbiko = getFirstBus(fromAbiko);

      // 上記処理を，forと配列を用いてまとめる
      final List<BusSchedule> busSchedules = [
        firstBusForKashiwa,
        firstBusForShinkamagaya,
        firstBusForHokuso,
        firstBusFromKashiwa,
        firstBusFromShinkamagaya,
        firstBusFromShiroi,
        firstBusFromHokuso,
        firstBusFromShinKashiwa,
        firstBusFromAbiko
      ];

      final List<Duration> times =
          List.filled(busSchedules.length, const Duration());

      // 一番はやく出発するバスを取得
      for (int i = 0; i < busSchedules.length; i++) {
        if (busSchedules[i].id == -1) {
          times[i] = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  busSchedules[i].departureTime.hour,
                  busSchedules[i].departureTime.minute)
              .difference(now);
        }
      }
      // countdowntextを更新
      setState(() {
        // 最終便の時刻を過ぎていたら何も表示しない
        _countdownTextForKashiwa = times[0].isNegative
            ? '🔚'
            : '${times[0].inMinutes.remainder(60)}分${times[0].inSeconds.remainder(60)}秒';
        _countdownTextForShinkamagaya = times[1].isNegative
            ? '🔚'
            : '${times[1].inMinutes.remainder(60)}分${times[1].inSeconds.remainder(60)}秒';
        _countdownTextForHokuso = times[2].isNegative
            ? '🔚'
            : '${times[2].inMinutes.remainder(60)}分${times[2].inSeconds.remainder(60)}秒';
        _countdownTextFromKashiwa = times[3].isNegative
            ? '🔚'
            : '${times[3].inMinutes.remainder(60)}分${times[3].inSeconds.remainder(60)}秒';
        _countdownTextFromShinkamagaya = times[4].isNegative
            ? '🔚'
            : '${times[4].inMinutes.remainder(60)}分${times[4].inSeconds.remainder(60)}秒';
        _countdownTextFromShiroi = times[5].isNegative
            ? '🔚'
            : '${times[5].inMinutes.remainder(60)}分${times[5].inSeconds.remainder(60)}秒';
        _countdownTextFromHokuso = times[6].isNegative
            ? '🔚'
            : '${times[6].inMinutes.remainder(60)}分${times[6].inSeconds.remainder(60)}秒';
        _countdownTextFromShinKashiwa = times[7].isNegative
            ? '🔚'
            : '${times[7].inMinutes.remainder(60)}分${times[7].inSeconds.remainder(60)}秒';
        _countdownTextFromAbiko = times[8].isNegative
            ? '🔚'
            : '${times[8].inMinutes.remainder(60)}分${times[8].inSeconds.remainder(60)}秒';
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
    final List<Map<String, String>> fromSchoolBusses = [
      {
        'dest': busDetailFromSchool(getFirstBus(forKashiwa)),
        'time': _countdownTextForKashiwa
      },
      {
        'dest': busDetailFromSchool(getFirstBus(forShinkamagaya)),
        'time': _countdownTextForShinkamagaya
      },
      {
        'dest': busDetailFromSchool(getFirstBus(forHokuso)),
        'time': _countdownTextForHokuso
      }
    ];
    final List<Map<String, String>> toSchoolBusses = [
      {
        'dest': busDetailToSchool(getFirstBus(fromKashiwa)),
        'time': _countdownTextFromKashiwa
      },
      {
        'dest': busDetailToSchool(getFirstBus(fromShinkamagaya)),
        'time': _countdownTextFromShinkamagaya
      },
      {
        'dest': busDetailToSchool(getFirstBus(fromShiroi)),
        'time': _countdownTextFromShiroi
      },
      {
        'dest': busDetailToSchool(getFirstBus(fromHokuso)),
        'time': _countdownTextFromHokuso
      },
      {
        'dest': busDetailToSchool(getFirstBus(fromShinKashiwa)),
        'time': _countdownTextFromShinKashiwa
      },
      {
        'dest': busDetailToSchool(getFirstBus(fromAbiko)),
        'time': _countdownTextFromAbiko
      }
    ];
    return DefaultTabController(
      length: 2,
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
                // 校舎発
                ListView.builder(
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(
                              fromSchoolBusses[index]['dest']!,
                              style: TextStyle(
                                  fontSize: screenWidth > 830 ? 25.sp : 45.sp),
                            ),
                            subtitle: Text(
                              fromSchoolBusses[index]['time']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: screenWidth > 830 ? 50.sp : 90.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                    itemCount: fromSchoolBusses.length),
                // 校舎行き
                ListView.builder(
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(
                              toSchoolBusses[index]['dest']!,
                              style: TextStyle(
                                  fontSize: screenWidth > 830 ? 25.sp : 45.sp),
                            ),
                            subtitle: Text(
                              toSchoolBusses[index]['time']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: screenWidth > 830 ? 50.sp : 90.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                    itemCount: toSchoolBusses.length),
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
  final String station;
  final TimeOfDay departureTime;

  BusSchedule(this.id, this.station, this.departureTime);
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
