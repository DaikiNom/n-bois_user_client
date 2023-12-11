import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// NOTE: 本番では，情報はREST APIから取得する
// 通知の内容は[title, body, date, sender]の形式
List<busNotification> allNotifications = [
  busNotification(
    'サンプル通知1',
    'サンプル通知1の内容',
    DateTime(2023, 1, 1),
    'サンプル送信者1',
  ),
  busNotification(
    'サンプル通知2',
    'サンプル通知2の内容',
    DateTime(2023, 2, 1),
    'サンプル送信者2',
  ),
  busNotification(
    'サンプル通知3',
    'サンプル通知3の内容',
    DateTime(2023, 3, 1),
    'サンプル送信者3',
  ),
  busNotification(
    'サンプル通知4',
    'サンプル通知4の内容',
    DateTime(2023, 4, 1),
    'サンプル送信者4',
  ),
  busNotification(
    'サンプル通知5',
    'サンプル通知5の内容',
    DateTime(2023, 5, 1),
    'サンプル送信者5',
  ),
  busNotification(
    'サンプル通知6',
    'サンプル通知6の内容',
    DateTime(2023, 6, 1),
    'サンプル送信者6',
  ),
  busNotification(
    'サンプル通知7',
    'サンプル通知7の内容',
    DateTime(2023, 7, 1),
    'サンプル送信者7',
  ),
  busNotification(
    'サンプル通知8',
    'サンプル通知8の内容',
    DateTime(2023, 8, 1),
    'サンプル送信者8',
  ),
  busNotification(
    'サンプル通知9',
    'サンプル通知9の内容',
    DateTime(2023, 9, 1),
    'サンプル送信者9',
  ),
  busNotification(
    'サンプル通知10',
    'サンプル通知10の内容',
    DateTime(2023, 10, 1),
    'サンプル送信者10',
  ),
  busNotification(
    'サンプル通知11',
    'サンプル通知11の内容',
    DateTime(2023, 11, 1),
    'サンプル送信者11',
  ),
  busNotification(
    'サンプル通知12',
    'サンプル通知12の内容',
    DateTime(2023, 12, 1),
    'サンプル送信者12',
  ),
];

// 通知形式の定義
class busNotification {
  final String title;
  final String body;
  final DateTime date;
  final String sender;

  busNotification(this.title, this.body, this.date, this.sender);
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

// 通知画面
class _NotificationScreenState extends State<NotificationScreen> {
  DateFormat format = DateFormat('yyyy/MM/dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知一覧'),
      ),
      body: ListView.builder(
        itemCount: allNotifications.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(allNotifications[index].title),
              subtitle: allNotifications[index].body.length > 30
                  ? Text(allNotifications[index].body.replaceRange(
                      30, allNotifications[index].body.length, '...'))
                  : Text(allNotifications[index].body),
              trailing: Text(format.format(allNotifications[index].date)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailScreen(
                      notification: allNotifications[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 通知詳細画面
class NotificationDetailScreen extends StatelessWidget {
  final busNotification notification;
  const NotificationDetailScreen({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知詳細'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
          ),
          ListTile(
            title: const Text('送信者'),
            subtitle: Text(notification.sender),
          ),
          ListTile(
            title: const Text('送信日時'),
            subtitle: Text(DateFormat('yyyy/MM/dd').format(notification.date)),
          ),
        ],
      ),
    );
  }
}
