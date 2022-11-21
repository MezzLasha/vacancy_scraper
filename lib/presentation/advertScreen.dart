// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/myCustomWidgets.dart';
import 'package:vacancy_scraper/presentation/home.dart';
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
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: adBlurBanner(detailedAd.imageUrl)),
                    Html(
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
                    const SizedBox(
                      height: 30,
                    ),
                    if (detailedAd.attachmentUrl != '')
                      Card(
                        margin: const EdgeInsets.all(12),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'მიმაგრებული ფაილი',
                                    style: GoogleFonts.notoSansGeorgian(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  Icon(
                                    Icons.attach_file,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    launchWebUrl(
                                        context, detailedAd.attachmentUrl);
                                  },
                                  onLongPress: () {
                                    final snackbar = SnackBar(
                                        content: Text(
                                          detailedAd.attachmentUrl,
                                          style: GoogleFonts.notoSans(
                                            color: Theme.of(context)
                                                .primaryTextTheme
                                                .labelMedium!
                                                .color,
                                          ),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Theme.of(context)
                                            .dialogBackgroundColor,
                                        action: SnackBarAction(
                                            label: 'გახსნა',
                                            textColor: Theme.of(context)
                                                .primaryTextTheme
                                                .displayMedium!
                                                .color,
                                            onPressed: () {
                                              launchWebUrl(context,
                                                  detailedAd.attachmentUrl);
                                            }));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  child: Text(
                                    detailedAd.attachmentUrl
                                        .split('jobs/')[1]
                                        .split('/')[1],
                                    style: GoogleFonts.notoSans(
                                        color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        ));
  }
}
