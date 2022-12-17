import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/bloc/operation_events.dart';
import 'package:vacancy_scraper/bloc/user_bloc.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/presentation/home.dart';
import 'package:vacancy_scraper/repositories/databaseRepo.dart';

import '../custom/myOpenContainer.dart';
import 'advertScreen.dart';

class SavedAdverts extends StatefulWidget {
  final List<String> announcementIDs;
  const SavedAdverts({super.key, required this.announcementIDs});

  @override
  State<SavedAdverts> createState() => _SavedAdvertsState();
}

class _SavedAdvertsState extends State<SavedAdverts> {
  @override
  void initState() {
    loadAnnouncements =
        _getSavedAnnouncements().then((value) => loadedAnnouncements = value);
    super.initState();
  }

  var loadAnnouncements;

  List<Announcement> loadedAnnouncements = [];

  Future<List<Announcement>> _getSavedAnnouncements() async {
    List<Announcement> _announcements = [];
    for (var announcement in widget.announcementIDs) {
      _announcements
          .add(await DatabaseRepository().getDetailedAdFromID(announcement));
    }
    return _announcements;
  }

  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverAppBar.large(
          title: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var top = constraints.biggest.height;
              if (top > 60) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16.0, left: 4),
                  child: AutoSizeText(
                    'შენახული განცხადებები',
                    maxLines: 1,
                    softWrap: false,
                    maxFontSize: 19,
                    minFontSize: 10,
                    overflow: TextOverflow.fade,
                  ),
                );
              } else {
                return const AutoSizeText(
                  'შენახული განცხადებები',
                  maxLines: 3,
                );
              }
            },
          ),
        ),
        SliverToBoxAdapter(
            child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state.operationEvent is SuccessfulEvent) {
              for (var announcement in loadedAnnouncements) {
                if (!state.user.savedAnnouncementIDs
                    .contains(announcement.jobId)) {
                  setState(() {
                    loadedAnnouncements.remove(announcement);
                  });
                  break;
                }
              }
            }
          },
          child: FutureBuilder(
              future: loadAnnouncements,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LinearProgressIndicator();
                }

                if (loadedAnnouncements.isEmpty) {
                  return const NoSavedAnnouncementWidget();
                }

                return ListView.builder(
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: loadedAnnouncements.length,
                    itemBuilder: (context, index) {
                      return SavedAdvertisementListItem(
                        item: loadedAnnouncements[index],
                      );
                    });
              }),
        )),
      ],
    ));
  }
}

class NoSavedAnnouncementWidget extends StatelessWidget {
  const NoSavedAnnouncementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'დამახსოვრებული განცხადებები გამოჩნდება აქ',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.tertiary),
        ));
  }
}

class SavedAdvertisementListItem extends StatelessWidget {
  final Announcement item;

  const SavedAdvertisementListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyOpenContainer(
      closedColor: Theme.of(context).colorScheme.background,
      closedElevation: 0,
      middleColor: Theme.of(context).colorScheme.background,
      transitionType: MyOpenContainerTransitionType.fadeThrough,
      openColor: Theme.of(context).colorScheme.background,
      closedShape: const Border(),
      closedBuilder: (context, tap) {
        var _tapDownPosition;
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
                    await Clipboard.setData(ClipboardData(text: item.jobLink));
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
                PopupMenuItem<int>(
                  value: 1,
                  onTap: () {
                    context
                        .read<UserBloc>()
                        .add(SaveAnnouncement(announcementID: item.jobId));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("წაშლა"),
                      Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.error,
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
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
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
                      ListTileSecondary(
                        item: item,
                      ),

                      // buildAttributeWidgets(item, context)
                      AttributeWidget(
                        item: item,
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<UserBloc>()
                          .add(SaveAnnouncement(announcementID: item.jobId));
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.error,
                    ))
              ],
            ),
          ),
        );
      },
      openBuilder: (context, action) {
        return AdvertScreen(announcement: item);
      },
    );
  }
}
