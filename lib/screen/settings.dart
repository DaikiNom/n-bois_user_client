import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      // 利用規約・プライバシーポリシー・ライセンスへの画面をlist表示する
      body: ListView(
        children: [
          ListTile(
            title: const Text('利用規約'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Terms()));
            },
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Privacy()));
            },
          ),
          ListTile(
            title: const Text('ライセンス'),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'N-BOIS',
              applicationVersion: '0.1.1',
              applicationLegalese: 'Copyrights © 2023 N-BOIS Developer Team',
            ),
          ),
          const Text(
            'このアプリは，二松学舎大学附属柏高等学校の許諾・協力のもと開発・運営されているものです．',
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              launchUrl(Uri.parse('https://www.nishogakusha-kashiwa.ed.jp/'));
            },
            child: const Text('二松学舎大学附属柏高等学校'),
          ),
        ],
      ),
    );
  }
}

// 利用規約
class Terms extends StatelessWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: const Center(
        child: Text('利用規約'),
      ),
    );
  }
}

// プライバシーポリシー
class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
      ),
      body: const Center(
        child: Text('プライバシーポリシー'),
      ),
    );
  }
}
