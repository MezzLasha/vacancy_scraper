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
  final String websiteLink;

  const ProviderScreen({
    Key? key,
    required this.providerName,
    required this.providerLink,
    required this.websiteLink,
  }) : super(key: key);

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  late JobProvider _jobProvider;
  late Future<JobProvider> future;

  @override
  void initState() {
    print(widget.websiteLink);
    future = DatabaseRepository().getProviderDetails(widget.providerLink);
    super.initState();
  }

  var _tapDownPosition;
  var top = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<JobProvider> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null &&
              snapshot.hasData) {
            _jobProvider = snapshot.data!;
            return CustomScrollView(
              controller: ScrollController(),
              slivers: [
                buildAppBar(),
                buildHtmlDescription(),
                buildHorizontalBar(context),
                buildAdsList(),
              ],
            );
          } else {
            return CustomScrollView(
              controller: ScrollController(),
              slivers: [
                buildAppBar(),
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(),
                )
              ],
            );
            ;
          }
        },
      ),
    );
  }

  SliverToBoxAdapter buildAdsList() {
    return SliverToBoxAdapter(
        child: ListView.builder(
      controller: ScrollController(),
      shrinkWrap: true,
      itemCount: _jobProvider.announcements.length,
      itemBuilder: (context, index) {
        final item = _jobProvider.announcements[index];
        return OpenContainer(
          closedColor: Theme.of(context).colorScheme.background,
          closedElevation: 0,
          middleColor: Theme.of(context).colorScheme.background,
          openColor: Theme.of(context).colorScheme.background,
          closedShape: const Border(),
          closedBuilder: (context, tap) {
            return InkWell(
              onTapDown: (TapDownDetails details) {
                _tapDownPosition = details.globalPosition;
              },
              onTap: () => tap(),
              onLongPress: () async {
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;

                showMenu(
                  context: context,
                  items: [
                    PopupMenuItem<int>(
                      value: 1,
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: item.jobLink));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("ბმული"),
                          Icon(
                            Icons.link,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                  position: RelativeRect.fromLTRB(
                    _tapDownPosition.dx,
                    _tapDownPosition.dy,
                    overlay.size.width - _tapDownPosition.dx,
                    overlay.size.height - _tapDownPosition.dy,
                  ),
                );
              },
              splashFactory: InkSparkle.splashFactory,
              child: Ink(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 12),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                    width: 1.0,
                  ),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            item.jobName,
                            maxLines: 2,
                            style: GoogleFonts.notoSansGeorgian(),
                          ),
                          ...buildListTileSecondary(item, context),
                          buildAttributeWidgets(item, context)
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
    ));
  }

  SliverToBoxAdapter buildHtmlDescription() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Html(
          data: _jobProvider.description,
          style: {
            "p": Style(color: Theme.of(context).colorScheme.secondary),
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
    );
  }

  SliverAppBar buildHorizontalBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      toolbarHeight: 45,
      title: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            if (_jobProvider.announcements.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: FilterChip(
                  selected: true,
                  labelPadding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _jobProvider.announcements.length.toString(),
                        style: GoogleFonts.notoSans(),
                      ),
                      const Text('  განცხადება'),
                    ],
                  ),
                  onSelected: (bool value) {},
                  showCheckmark: false,
                ),
              ),
            if (widget.websiteLink != '')
              Padding(
                  padding:
                      const EdgeInsets.only(left: 12, bottom: 12, right: 12),
                  child: ChoiceChip(
                    tooltip: 'ბრაუზერში გახსნა',
                    onSelected: (_) {
                      launchWebUrl(context, widget.websiteLink);
                    },
                    label: Text(
                      Uri.parse(widget.websiteLink).host,
                    ),
                    selected: false,
                  ))
          ],
        ),
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
            return AutoSizeText(
              widget.providerName,
              maxLines: 3,
            );
          }
        },
      ),
    );
  }
}
