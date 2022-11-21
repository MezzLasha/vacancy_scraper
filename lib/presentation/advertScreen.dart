// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/myCustomWidgets.dart';
import 'package:vacancy_scraper/repositories/databaseRepo.dart';

class AdvertScreen extends StatefulWidget {
  final Announcement announcement;
  const AdvertScreen({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  State<AdvertScreen> createState() => _AdvertScreenState();
}

class _AdvertScreenState extends State<AdvertScreen> {
  late Future<Announcement> future;
  late Announcement detailedAd;
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>? scm;

  @override
  void initState() {
    future = DatabaseRepository().getDetailedAd(widget.announcement);
    future.then((value) async {
      if (value.description.contains('ინგლისურ ენაზე')) {
        var banner = MaterialBanner(
            content: Text(
              'English Version Found!',
              style: GoogleFonts.notoSans(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (scm != null) {
                      scm!.close.call();
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvertScreen(
                                  announcement: widget.announcement.copyWith(
                                      jobLink:
                                          ('https://jobs.ge${value.description.split('">ინგლისურ ენაზე')[0].split('href="')[1]}')
                                              .replaceAll('&amp;', '&')),
                                )));
                  },
                  child: const Text('Open'))
            ]);
        scm = ScaffoldMessenger.of(context).showMaterialBanner(banner);
        await Future.delayed(const Duration(seconds: 10));
        scm!.close.call();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (scm != null) {
      try {
        scm!.close.call();
      } catch (e) {
        print('couldn\'t dispose');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.announcement.jobName,
              style: GoogleFonts.notoSansGeorgian(fontSize: 17)),
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              detailedAd = snapshot.data!;

              return SingleChildScrollView(
                child: Html(
                  data: detailedAd.description,
                  onLinkTap: (url, _, attributes, element) {
                    if (url == null) {
                      showSnackBar(context, 'მოხდა შეცდომა! ');
                      return;
                    }
                    if (url.startsWith('/en/ads/')) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdvertScreen(
                                    announcement: widget.announcement.copyWith(
                                        jobLink:
                                            ('https://jobs.ge${detailedAd.description.split('">ინგლისურ ენაზე')[0].split('href="')[1]}')
                                                .replaceAll('&amp;', '&')),
                                  )));
                    }
                    if (url.startsWith('http')) {
                      launchWebUrl(context, url);
                    } else {
                      openIntent(context, url);
                    }
                  },
                ),
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        ));
  }
}
