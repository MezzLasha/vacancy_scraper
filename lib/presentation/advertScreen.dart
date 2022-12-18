import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/custom/myOpenContainer.dart';

import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/presentation/home.dart';
import 'package:vacancy_scraper/presentation/provider_screen.dart';
import 'package:vacancy_scraper/repositories/scraperRepo.dart';

import '../custom/customTextSelection.dart';

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
  void hideBanner() async {
    if (scm != null) {
      try {
        await Future.delayed(const Duration(seconds: 1));
        scm!.close.call();
      } catch (e) {
        print('couldn\'t dispose');
      }
    }
  }

  @override
  void initState() {
    future = DatabaseRepository().getDetailedAd(widget.announcement);
    future.then((value) async {
      if (value.description.contains('ინგლისურ ენაზე') &&
          value.description.contains('იხილეთ ამ განცხადების სრული ტექსტი')) {
        var banner = MaterialBanner(
            content: Text(
              'English Version',
              style: GoogleFonts.notoSans(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    hideBanner();
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

        hideBanner();
      } else if (value.description.contains('რუსულ ენაზე') &&
          value.description.contains('იხილეთ ამ განცხადების სრული ტექსტი')) {
        var banner = MaterialBanner(
            content: Text(
              'Русская версия',
              style: GoogleFonts.notoSans(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    hideBanner();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvertScreen(
                                  announcement: widget.announcement.copyWith(
                                      jobLink:
                                          ('https://jobs.ge${value.description.split('">რუსულ ენაზე')[0].split('href="')[1]}')
                                              .replaceAll('&amp;', '&')),
                                )));
                  },
                  child: const Text('войти'))
            ]);
        scm = ScaffoldMessenger.of(context).showMaterialBanner(banner);
        await Future.delayed(const Duration(seconds: 10));

        hideBanner();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    hideBanner();
    super.dispose();
  }

  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              top = constraints.biggest.height;
              if (top > 60) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 4),
                  child: AutoSizeText(
                    widget.announcement.jobName,
                    maxLines: 1,
                    softWrap: false,
                    maxFontSize: 19,
                    minFontSize: 10,
                    overflow: TextOverflow.fade,
                  ),
                );
              } else {
                return AutoSizeText(
                  widget.announcement.jobName,
                  maxLines: 3,
                );
              }
            },
          ),
          actions: [
            PopupMenuButton(
              tooltip: 'სხვა',
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 1,
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.announcement.jobLink));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("ბმული"),
                        Icon(
                          Icons.link,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    onTap: () {
                      launchWebUrl(context, widget.announcement.jobLink);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ბრაუზერში გახსნა'),
                        Icon(
                          Icons.open_in_browser_outlined,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                ];
              },
            )
          ],
        ),
        SliverToBoxAdapter(
            child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              detailedAd = snapshot.data!;

              return Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AdvertisementImage(imageUrl: detailedAd.imageUrl),
                              if (widget.announcement.jobProvider != '')
                                Flexible(
                                    child: MyOpenContainer(
                                  closedColor:
                                      Theme.of(context).colorScheme.background,
                                  closedElevation: 0,
                                  middleColor:
                                      Theme.of(context).colorScheme.background,
                                  openColor:
                                      Theme.of(context).colorScheme.background,
                                  closedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  transitionType:
                                      MyOpenContainerTransitionType.fadeThrough,
                                  closedBuilder: (context, action) {
                                    return Container(
                                      height: 40,
                                      padding: const EdgeInsets.all(1),
                                      child: OutlinedButton(
                                          onPressed: () => action(),
                                          style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary),
                                          child: Text(
                                            widget.announcement.jobProvider,
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    );
                                  },
                                  openBuilder: (context, action) {
                                    return ProviderScreen(
                                      providerName:
                                          widget.announcement.jobProvider,
                                      providerLink:
                                          widget.announcement.jobProviderLink,
                                      websiteLink: widget.announcement.website,
                                    );
                                  },
                                )),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'გამოქვეყნდა: ${widget.announcement.startDate}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'ბოლო ვადა: ${widget.announcement.endDate.substring(0, widget.announcement.endDate.length - 8)}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: ScrollController(),
                      child: SelectableHtml(
                        selectionControls: MaterialYouTextSelectionControls(),
                        data: detailedAd.description,
                        shrinkWrap: true,
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
                                          announcement: widget.announcement
                                              .copyWith(
                                                  jobLink:
                                                      ('https://jobs.ge${detailedAd.description.split('">ინგლისურ ენაზე')[0].split('href="')[1]}')
                                                          .replaceAll(
                                                              '&amp;', '&')),
                                        )));
                          }
                          if (url.startsWith('http')) {
                            launchWebUrl(context, url);
                          } else {
                            openIntent(context, url);
                          }
                        },
                      ),
                    ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style:
                                      GoogleFonts.notoSans(color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).systemGestureInsets.bottom,
                  ),
                ],
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        )),
      ],
    ));
  }
}
