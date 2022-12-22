import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

var _selection = 'ქართული';

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('პარამეტრები'),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          PopupMenuButton<String>(
            position: PopupMenuPosition.under,
            onSelected: (String value) {
              setState(() {
                showSnackBar(
                    context,
                    _selection == value
                        ? 'ენის შეცვლის ფუნქცია მალე დაემატება!'
                        : 'Language options will be added soon!');
              });
            },
            child: ListTile(
              title: const Text('ენა'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selection,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'ქართული',
                child: Text('ქართული'),
              ),
              const PopupMenuItem<String>(
                value: 'English',
                child: Text('English'),
              ),
            ],
          ),
          ListTile(
            title: const Text('Play Store-ზე შეფასება'),
            onTap: () => LaunchReview.launch(),
          ),
          ListTile(
              title: const Text('ფუნქციის მოთხოვნა'),
              onTap: () =>
                  sendEmail('ფუნქციის მოთხოვნა', 'mezzlasha@gmail.com', '')),
          ListTile(
              title: const Text('Bug report'),
              onTap: () => sendEmail('Bug report', 'mezzlasha@gmail.com', '')),
        ]))
      ],
    ));
  }
}
