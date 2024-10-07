import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
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
              launchUrl(Uri.parse('https://docs.n-bois.com/terms/'));
            },
          ),
          ListTile(
            title: const Text('プライバシーポリシー'),
            onTap: () {
              launchUrl(Uri.parse('https://docs.n-bois.com/privacypolicy/'));
            },
          ),
          ListTile(
            title: const Text('ライセンス'),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'N-BOIS',
              applicationVersion: '0.2.0',
              applicationLegalese:
                  'Copyrights © 2023 - ${DateTime.now().year} N-BOIS Developer Team',
            ),
          ),
          ListTile(
            title: const Text('GitHub: DaikiNom/n-bois_user_client'),
            onTap: () {
              launchUrl(
                  Uri.parse('https://github.com/DaikiNom/n-bois_user_client'));
            },
          ),
          const Text(
            'このアプリは，二松学舎大学附属柏高等学校の許諾・協力のもと\r\n開発・運営されているものです．',
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
