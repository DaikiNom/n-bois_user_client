import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nbois_user_client/screen/settings.dart';

// 通知の内容を格納するクラス
class busNotification {
  final String title;
  final String body;
  final DateTime date;
  final String created_by;

  busNotification(this.title, this.body, this.date, this.created_by);
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

// 通知画面
class _NotificationScreenState extends State<NotificationScreen> {
  List<busNotification> allNotifications = [];
  final client = Supabase.instance.client;
  getNotifications() async {
    // 通知を更新日の新しい順に取得
    final response = await client
        .from('notifications')
        .select()
        .order('created_at', ascending: false)
        .execute();
    for (var i = 0; i < response.data!.length; i++) {
      allNotifications.add(busNotification(
          response.data![i]['title'],
          response.data![i]['body'],
          DateTime.parse(response.data![i]['created_at']),
          response.data![i]['created_by']));
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  final DateFormat format = DateFormat('yyyy/MM/dd');
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
        title: const Text('通知一覧'),
        actions: [
          IconButton(
            onPressed: () {
              allNotifications = [];
              getNotifications();
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
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
            subtitle: Text(notification.created_by),
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
