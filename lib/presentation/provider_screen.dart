import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/models/provider_model.dart';
import 'package:vacancy_scraper/presentation/advertScreen.dart';
import 'package:vacancy_scraper/presentation/home.dart';

import '../repositories/databaseRepo.dart';

class ProviderScreen extends StatefulWidget {
  final String providerName;
  final String providerLink;

  const ProviderScreen({
    Key? key,
    required this.providerName,
    required this.providerLink,
  }) : super(key: key);

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  late JobProvider _jobProvider;
  late Future<JobProvider> future;

  @override
  void initState() {
    future = DatabaseRepository().getProviderDetails(widget.providerLink);
    super.initState();
  }

  var _tapDownPosition;
  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildAppBar(),
          SliverToBoxAdapter(
            child: FutureBuilder(
              future: future,
              builder: (context, AsyncSnapshot<JobProvider> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null &&
                    snapshot.hasData) {
                  _jobProvider = snapshot.data!;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _jobProvider.description,
                          style: {
                            "p": Style(
                                color: Theme.of(context).colorScheme.secondary),
                          },
                          onLinkTap: (url, _, attributes, element) {
                            if (url == null) {
                              showSnackBar(context, 'მოხდა შეცდომა! ');
                              return;
                            }

                            if (url.startsWith('http')) {
                              launchWebUrl(context, url);
                            } else {
                              openIntent(context, url);
                            }
                          },
                        ),
                      ),
                      if (_jobProvider.announcements.isNotEmpty)
                        ListView.builder(
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemCount: _jobProvider.announcements.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0 &&
                                _jobProvider.announcements.isNotEmpty) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.only(left: 12, bottom: 12),
                                child: FilterChip(
                                  selected: true,
                                  label: const Text('განცხადება'),
                                  avatar: Text(
                                    _jobProvider.announcements.length
                                        .toString(),
                                    style: GoogleFonts.notoSans(),
                                  ),
                                  onSelected: (bool value) {},
                                  showCheckmark: false,
                                ),
                              );
                            }

                            final item = _jobProvider.announcements[index - 1];
                            return OpenContainer(
                              closedColor:
                                  Theme.of(context).colorScheme.background,
                              closedElevation: 0,
                              middleColor:
                                  Theme.of(context).colorScheme.background,
                              openColor:
                                  Theme.of(context).colorScheme.background,
                              closedShape: const Border(),
                              closedBuilder: (context, tap) {
                                return InkWell(
                                  onTapDown: (TapDownDetails details) {
                                    _tapDownPosition = details.globalPosition;
                                  },
                                  onTap: () => tap(),
                                  onLongPress: () async {
                                    final RenderBox overlay =
                                        Overlay.of(context)
                                            .context
                                            .findRenderObject() as RenderBox;

                                    showMenu(
                                      context: context,
                                      items: [
                                        PopupMenuItem<int>(
                                          value: 1,
                                          onTap: () async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: item.jobLink));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("ბმული"),
                                              Icon(
                                                Icons.link,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      position: RelativeRect.fromLTRB(
                                        _tapDownPosition.dx,
                                        _tapDownPosition.dy,
                                        overlay.size.width -
                                            _tapDownPosition.dx,
                                        overlay.size.height -
                                            _tapDownPosition.dy,
                                      ),
                                    );
                                  },
                                  splashFactory: InkSparkle.splashFactory,
                                  child: Ink(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        right: 16,
                                        top: 12,
                                        bottom: 12),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.2),
                                        width: 1.0,
                                      ),
                                    )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                item.jobName,
                                                maxLines: 2,
                                                style: GoogleFonts
                                                    .notoSansGeorgian(),
                                              ),
                                              ...buildListTileSecondary(
                                                  item, context),
                                              buildAttributeWidgets(
                                                  item, context)
                                            ],
                                          ),
                                        ),
                                        // advertImage(item.imageUrl),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              openBuilder: (context, action) {
                                return AdvertScreen(announcement: item);
                              },
                            );
                          },
                        )
                    ],
                  );
                } else {
                  return const LinearProgressIndicator();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar buildAppBar() {
    return SliverAppBar.large(
      title: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;
          if (top > 60) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 4),
              child: AutoSizeText(
                widget.providerName,
                maxLines: 1,
                softWrap: false,
                maxFontSize: 19,
                minFontSize: 10,
                overflow: TextOverflow.fade,
              ),
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AutoSizeText(
                  widget.providerName,
                  maxLines: 3,
                ),
                FutureBuilder(
                    future: future,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return advertImage(_jobProvider.imageUrl);
                      } else {
                        return const SizedBox.shrink();
                      }
                    }))
              ],
            );
          }
        },
      ),
    );
  }
}
