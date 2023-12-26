import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nbois_user_client/screen/settings.dart';

List<BusSchedule> forKashiwa = [];
List<BusSchedule> forShinkamagaya = [];
List<BusSchedule> forHokuso = [];
List<BusSchedule> fromKashiwa = [];
List<BusSchedule> fromShinkamagaya = [];
List<BusSchedule> fromShiroi = [];
List<BusSchedule> fromHokuso = [];
List<BusSchedule> fromShinKashiwa = [];
List<BusSchedule> fromAbiko = [];

// supabaseから時刻表を取得
getTimetable() async {
  final client = Supabase.instance.client;
  final response = await client
      .from('bus_schedules')
      .select('direction, station, departure_time, status')
      .execute();
  // 行き先，directionによってそれぞれの配列に格納
  for (var i = 0; i < response.data!.length; i++) {
    if (response.data![i]['direction'] == 'for') {
      if (response.data![i]['station'] == '柏' ||
          response.data![i]['station'] == '柏(二松駐車場)') {
        forKashiwa.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '新鎌ケ谷方面') {
        forShinkamagaya.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '北総方面') {
        forHokuso.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      }
    } else if (response.data![i]['direction'] == 'from') {
      if (response.data![i]['station'] == '柏' ||
          response.data![i]['station'] == '柏(二松駐車場)') {
        fromKashiwa.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '新鎌ケ谷') {
        fromShinkamagaya.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '白井' ||
          response.data![i]['station'] == '西白井') {
        fromShiroi.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '印旛日本医大' ||
          response.data![i]['station'] == '千葉ニュータウン' ||
          response.data![i]['station'] == '印西牧の原' ||
          response.data![i]['station'] == '小室') {
        fromHokuso.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '新柏') {
        fromShinKashiwa.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      } else if (response.data![i]['station'] == '我孫子') {
        fromAbiko.add(BusSchedule(
            response.data![i]['status'],
            response.data![i]['station'],
            TimeOfDay(
                hour: int.parse(
                    response.data![i]['departure_time'].split(':')[0]),
                minute: int.parse(
                    response.data![i]['departure_time'].split(':')[1]))));
      }
    }
  }
}

class BusCountdown extends StatefulWidget {
  const BusCountdown({Key? key}) : super(key: key);

  @override
  _BusCountdownState createState() => _BusCountdownState();
}

class _BusCountdownState extends State<BusCountdown> {
  String busDetailFromSchool(BusSchedule busSchedule) {
    if (busSchedule.id == -1) {
      return '本日の ${busSchedule.station}行き の運行は終了しました';
    } else if (busSchedule.id == 2) {
      return '次の ${busSchedule.station}(教職員優先) のバスまで';
    } else {
      return '次の ${busSchedule.station}行き のバスまで';
    }
  }

  String busDetailToSchool(BusSchedule busSchedule) {
    if (busSchedule.id == -1) {
      return '本日の ${busSchedule.station}発 の運行は終了しました';
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
        if (busSchedules[i].id != -1) {
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
        _countdownTextForKashiwa = times[0] == const Duration()
            ? '🔚'
            : '${times[0].inMinutes}分${(times[0].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextForShinkamagaya = times[1] == const Duration()
            ? '🔚'
            : '${times[1].inMinutes}分${(times[1].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextForHokuso = times[2] == const Duration()
            ? '🔚'
            : '${times[2].inMinutes}分${(times[2].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextFromKashiwa = times[3] == const Duration()
            ? '🔚'
            : '${times[3].inMinutes}分${(times[3].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextFromShinkamagaya = times[4] == const Duration()
            ? '🔚'
            : '${times[4].inMinutes}分${(times[4].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextFromShiroi = times[5] == const Duration()
            ? '🔚'
            : '${times[5].inMinutes}分${(times[5].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextFromHokuso = times[6] == const Duration()
            ? '🔚'
            : '${times[6].inMinutes}分${(times[6].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextFromShinKashiwa = times[7] == const Duration()
            ? '🔚'
            : '${times[7].inMinutes}分${(times[7].inSeconds % 60).toString().padLeft(2, '0')}秒';
        _countdownTextFromAbiko = times[8] == const Duration()
            ? '🔚'
            : '${times[8].inMinutes}分${(times[8].inSeconds % 60).toString().padLeft(2, '0')}秒';
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
          leading: IconButton(
            // 設定画面へ遷移
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: const Icon(Icons.settings),
          ),
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
    // 明日の始発の行き先を取得
    return BusSchedule(
        -1, busSchedules[0].station, const TimeOfDay(hour: 0, minute: 0));
  } else {
    return firstBus;
  }
}
