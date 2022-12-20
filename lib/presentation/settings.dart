import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/main.dart';

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
              leading: Icon(
                Icons.translate,
                color: const CustomColors(danger: Colors.lightBlueAccent)
                    .harmonized(Theme.of(context).colorScheme)
                    .danger,
              ),
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
            leading: Icon(Icons.rate_review_outlined,
                color: const CustomColors(danger: Colors.greenAccent)
                    .harmonized(Theme.of(context).colorScheme)
                    .danger),
            onTap: () => LaunchReview(),
          ),
        ]))
      ],
    ));
  }
}
