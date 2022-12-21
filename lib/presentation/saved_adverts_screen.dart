import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/bloc/user_bloc.dart';
import 'package:vacancy_scraper/custom/constants.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/presentation/auth/login_screen.dart';
import 'package:vacancy_scraper/presentation/auth/register_screen.dart';
import 'package:vacancy_scraper/presentation/home.dart';

import '../custom/myOpenContainer.dart';
import 'advertScreen.dart';

class SavedAdverts extends StatefulWidget {
  const SavedAdverts({super.key});

  @override
  State<SavedAdverts> createState() => _SavedAdvertsState();
}

class _SavedAdvertsState extends State<SavedAdverts> {
  @override
  void initState() {
    super.initState();
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
        SliverToBoxAdapter(child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.user.email.isEmpty) {
              //not logged in
              return const NotLoggedIn();
            }
            if (state.user.savedAnnouncements.isEmpty) {
              return const NoSavedAnnouncementWidget();
            }

            return ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: state.user.savedAnnouncements.length,
                itemBuilder: (context, index) {
                  return SavedAdvertisementListItem(
                    item: state.user.savedAnnouncements[index],
                  );
                });
          },
        )),
      ],
    ));
  }
}

class NotLoggedIn extends StatelessWidget {
  const NotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: (MediaQuery.of(context).size.height - 40) / 4,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: margin3),
          child: Column(
            children: [
              const SizedBox(
                height: margin2,
              ),
              Text(
                'განცხადებების შესანახად ანგარიშია საჭირო',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
              const SizedBox(
                height: margin2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen())),
                      child: const Text('შესვლა')),
                  const SizedBox(
                    width: margin1,
                  ),
                  FilledButton.tonal(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen())),
                      child: const Text('შექმნა')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NoSavedAnnouncementWidget extends StatelessWidget {
  const NoSavedAnnouncementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'დამახსოვრებული განცხადებები გამოჩნდება აქ',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.tertiary),
        ),
      ],
    );
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
        var tapDownPosition;
        return InkWell(
          onTapDown: (TapDownDetails details) {
            tapDownPosition = details.globalPosition;
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
                        .add(SaveAnnouncement(announcement: item));
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
                tapDownPosition.dx,
                tapDownPosition.dy,
                overlay.size.width - tapDownPosition.dx,
                overlay.size.height - tapDownPosition.dy,
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
                      AttributeWidget(
                        item: item,
                        disableNewAttr: true,
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<UserBloc>()
                          .add(SaveAnnouncement(announcement: item));
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
