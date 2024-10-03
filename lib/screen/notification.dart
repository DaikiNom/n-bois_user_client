import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nbois_user_client/screen/settings.dart';

// 通知の内容を格納するクラス
class busNotification {
  final String title;
  final String body;
  final DateTime date;
  final String? imageUrl;

  busNotification(this.title, this.body, this.date, this.imageUrl);
}

// urlを検出してリンクに変換
extension TextEx on Text {
  RichText urlToLink(
    BuildContext context,
  ) {
    final textSpans = <InlineSpan>[];

    data!.splitMapJoin(
      RegExp(
        r'https?://([\w-]+\.)+[\w-]+(/[\w-./?%&=#]*)?',
      ),
      onMatch: (Match match) {
        final _match = match[0] ?? '';
        textSpans.add(
          TextSpan(
            text: _match,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await launchUrl(
                    Uri.parse(_match),
                  ),
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        textSpans.add(
          TextSpan(
              text: text,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              )),
        );
        return '';
      },
    );

    return RichText(text: TextSpan(children: textSpans));
  }
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
        .order('created_at', ascending: false);
    for (var i = 0; i < response.length; i++) {
      allNotifications.add(busNotification(
          response[i]['title'],
          response[i]['body'],
          DateTime.parse(response[i]['created_at']),
          response[i]['image_url']));
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
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  notification.title,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(notification.body).urlToLink(context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  DateFormat('yyyy/MM/dd').format(notification.date),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              if (notification.imageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(notification.imageUrl!),
                ),
            ],
          ),
        ));
  }
}
