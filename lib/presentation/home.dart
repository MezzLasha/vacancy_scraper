// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:android_intent_plus/android_intent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vacancy_scraper/custom/custom_exceptions.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/custom/myOpenContainer.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/presentation/advertScreen.dart';
import 'package:vacancy_scraper/auth/login_screen.dart';
import 'package:vacancy_scraper/presentation/saved_adverts_screen.dart';
import 'package:vacancy_scraper/presentation/settings_screen.dart';
import 'package:vacancy_scraper/repositories/scraperRepo.dart';

import '../auth/bloc/operation_events.dart';
import '../auth/bloc/user_bloc.dart';
import '../custom/constants.dart';
import '../resume/resume_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 300;

  final PagingController<int, Announcement> _pagingController =
      PagingController(firstPageKey: 0);

  var isFabVisible = false;

  final refreshGlobalKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _scrollController.addListener(() {
      if (_scrollController.offset < 200) {
        setState(() {
          isFabVisible = false;
        });
      } else {
        if (_scrollController.position.userScrollDirection ==
                ScrollDirection.forward ||
            _scrollController.position.userScrollDirection ==
                ScrollDirection.idle) {
          if (!isFabVisible) {
            setState(() {
              isFabVisible = true;
            });
          }
        } else {
          if (isFabVisible) {
            setState(() {
              isFabVisible = false;
            });
          }
        }
      }
    });

    updateFilterValues();
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await DatabaseRepository()
          .fetchAnnouncements(pageKey, _pageSize, filter);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refresh() async {
    _pagingController.itemList = [];
    try {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      // refreshGlobalKey.currentState!.show();
      _pagingController.refresh();
    } catch (_) {}
  }

  void setFilter(
      String filterString, String category, String location, String jobType) {
    String cid = '';
    String lid = '';
    String jid = '';

    switch (category) {
      case '??????????????? ???????????????????????????':
        cid = '';
        break;
      case '???????????????????????????????????????/??????????????????????????????':
        cid = '1';
        break;
      case '???????????????????????????/??????????????????????????????':
        cid = '3';
        break;
      case '???????????????????????????':
        cid = '2';
        break;
      case 'PR/??????????????????????????????':
        cid = '4';
        break;
      case '?????????????????? ??????????????????????????? ???????????????????????????':
        cid = '18';
        break;
      case '???????????????????????????/??????????????????????????????/?????????????????????????????????':
        cid = '5';
        break;
      case '??????????????????????????????/?????????????????????':
        cid = '11';
        break;
      case '?????????????????????????????????':
        cid = '16';
        break;
      case '???????????????/?????????????????????????????????':
        cid = '17';
        break;
      case 'IT/????????????????????????????????????':
        cid = '6';
        break;
      case '???????????????/????????????????????????????????????':
        cid = '13';
        break;
      case '???????????????????????????':
        cid = '12';
        break;
      case '???????????????????????????':
        cid = '7';
        break;
      case '????????????????????????/????????????????????????':
        cid = '8';
        break;
      case '????????????????????????/????????????':
        cid = '14';
        break;
      case '???????????????':
        cid = '10';
        break;
      case '????????????':
        cid = '9';
        break;

      default:
        '';
    }

    switch (location) {
      case '??????????????????????????? ?????????????????????':
        lid = '';
        break;
      case '?????????????????????':
        lid = '1';
        break;
      case '??????????????????????????? ???/???':
        lid = '15';
        break;
      case '?????????????????? ???/???':
        lid = '14';
        break;
      case '???????????????':
        lid = '9';
        break;
      case '?????????????????????':
        lid = '8';
        break;
      case '??????????????????':
        lid = '3';
        break;
      case '??????????????????-????????????????????????':
        lid = '4';
        break;
      case '????????????-?????????????????????, ??????. ?????????????????????':
        lid = '12';
        break;
      case '???????????????????????????-???????????? ?????????????????????':
        lid = '13';
        break;
      case '??????????????????-????????????????????????':
        lid = '7';
        break;
      case '??????????????? ??????????????????':
        lid = '5';
        break;
      case '???????????? ??????????????????':
        lid = '6';
        break;
      case '?????????????????????':
        lid = '16';
        break;
      case '?????????????????????????????????':
        lid = '17';
        break;

      default:
        '';
    }

    switch (jobType) {
      case '??????????????? ????????????????????????':
        jid = '';
        break;
      case '??????????????????????????????':
        jid = '1';
        break;
      case '?????????????????????????????????':
        jid = '2';
        break;
      case '????????????':
        jid = '5';
        break;
      case '???????????????????????????':
        jid = '4';
        break;
      case '??????????????????????????????':
        jid = '3';
        break;

      default:
        '';
    }
    queryText = filterString;
    filter = '&q=$queryText&cid=$cid&lid=$lid&jid=$jid&for_scroll=yes';
  }

  String filter = '&q=&cid=&lid=&jid=&for_scroll=yes';
  String queryText = '';

  String categoryValue = '??????????????? ???????????????????????????';
  String locationValue = '??????????????????????????? ?????????????????????';
  String jobTypeValue = '??????????????? ????????????????????????';

  void updateFilterValues() {
    setState(() {
      selectedFilter[0] = categoryValue;
      selectedFilter[1] = locationValue;
      selectedFilter[2] = jobTypeValue;
    });
  }

  Future<void> searchForAds(String filterString) async {
    updateFilterValues();
    setFilter(
        filterString, selectedFilter[0], selectedFilter[1], selectedFilter[2]);

    Navigator.pop(context);
    _pagingController.itemList = [];
    await _refresh();
  }

  Future<void> searchForAdsFromMainScreen(String filterString) async {
    updateFilterValues();
    setFilter(
        filterString, selectedFilter[0], selectedFilter[1], selectedFilter[2]);
    _pagingController.itemList = [];
    await _refresh();
  }

  var textFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildJumptoTopFab(context),
          buildSearchFab(context),
        ],
      ),
      drawerEnableOpenDragGesture: true,
      drawer: NavigationDrawer(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: margin1, right: margin1),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.top + margin1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: margin1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedCrossFade(
                            firstChild: SizedBox(
                              height: 40,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ));
                                },
                                label: const Text('??????????????????'),
                                icon: const Icon(
                                  Icons.person,
                                  size: 24,
                                ),
                              ),
                            ),
                            secondChild: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surface,
                                  radius: 30,
                                  child: const Icon(
                                    Icons.person,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  context.watch<UserBloc>().state.user.name,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  context
                                      .watch<UserBloc>()
                                      .state
                                      .user
                                      .jobCategory,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            crossFadeState:
                                context.watch<UserBloc>().state.user.email == ''
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                            sizeCurve: Curves.easeInOutCubicEmphasized,
                            duration: const Duration(milliseconds: 300)),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 16,
                    ),
                    NavDrawerListTile(
                      selected: true,
                      icon: Icons.newspaper_outlined,
                      title: '??????????????????????????????',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    NavDrawerListTile(
                        selected: false,
                        icon: Icons.favorite_outline,
                        title: '??????????????????????????????????????????',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedAdverts(),
                              ));
                        }),
                    NavDrawerListTile(
                        selected: false,
                        icon: Icons.post_add,
                        title: '??????????????? ????????????????????? ????????????????????????',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResumeScreen(),
                              ));
                        }),
                    NavDrawerListTile(
                      selected: false,
                      icon: Icons.translate,
                      title: '?????????????????????????????????',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ));
                      },
                    ),
                    if (context.watch<UserBloc>().state.user.email != '' &&
                        MediaQuery.of(context).orientation ==
                            Orientation.landscape)
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(top: margin2),
                        child: FilledButton.tonalIcon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('????????????')),
                                    TextButton(
                                        onPressed: () {
                                          context
                                              .read<UserBloc>()
                                              .add(LogoutUser());
                                          Navigator.pop(context);
                                        },
                                        child: const Text('??????')),
                                  ],
                                  title: const Text('????????????????????????????????? ??????????????????'),
                                  alignment: Alignment.center,
                                  content: const Text(
                                      '??????????????????????????? ??????????????? ????????????????????????????????? ?????????????????????????'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout_outlined),
                            label: const Text('??????????????????')),
                      )
                  ],
                )
              ],
            ),
          ),
        ),
        if (context.watch<UserBloc>().state.user.email != '' &&
            MediaQuery.of(context).orientation == Orientation.portrait)
          Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(
                left: margin1,
                bottom: MediaQuery.of(context).systemGestureInsets.bottom),
            child: FilledButton.tonalIcon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('????????????')),
                        TextButton(
                            onPressed: () {
                              context.read<UserBloc>().add(LogoutUser());
                              Navigator.pop(context);
                            },
                            child: const Text('??????')),
                      ],
                      title: const Text('????????????????????????????????? ??????????????????'),
                      alignment: Alignment.center,
                      content:
                          const Text('??????????????????????????? ??????????????? ????????????????????????????????? ?????????????????????????'),
                    ),
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                label: const Text('??????????????????')),
          )
      ]),
      appBar: buildAppBar(),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          final operationEvent = state.operationEvent;
          if (operationEvent is ErrorEvent) {
            final error = operationEvent.error;
            if (error is SaveAnnouncementError) {
              showSnackBar(context, error.message);
            }
          }
        },
        child: RefreshIndicator(
            key: refreshGlobalKey,
            onRefresh: _refresh,
            child: buildPagedListView()),
      ),
    );
  }

  FloatingActionButton buildSearchFab(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: '????????????????????? ????????????????????????',
      onPressed: () {
        showMyBottomDialog(
            context,
            [
              TextFormField(
                key: textFieldKey,
                initialValue: queryText,
                decoration: InputDecoration(
                    labelText: '????????????????????? ??????????????????',
                    labelStyle: GoogleFonts.notoSansGeorgian().copyWith(
                        overflow: TextOverflow.ellipsis, fontSize: 15),
                    helperMaxLines: 1,
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: '???????????????????????????',
                      helperMaxLines: 1,
                      border: OutlineInputBorder()),
                  value: categoryValue,
                  items: category.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                      ),
                    );
                  }).toList(),
                  onChanged: ((value) {
                    setState(() {
                      categoryValue = value!;
                    });
                  })),
              const SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: '?????????????????????',
                      labelStyle: GoogleFonts.notoSansGeorgian().copyWith(
                          overflow: TextOverflow.ellipsis, fontSize: 15),
                      helperMaxLines: 1,
                      border: const OutlineInputBorder()),
                  value: locationValue,
                  items: location.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: ((value) {
                    setState(() {
                      locationValue = value!;
                    });
                  })),
              const SizedBox(
                height: 15,
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: '??????????????????????????? ????????????',
                      labelStyle: GoogleFonts.notoSansGeorgian().copyWith(
                          overflow: TextOverflow.ellipsis, fontSize: 15),
                      helperMaxLines: 1,
                      border: const OutlineInputBorder()),
                  value: jobTypeValue,
                  items: jobType.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: ((value) {
                    setState(() {
                      jobTypeValue = value!;
                    });
                  })),
              const SizedBox(
                height: 35,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  height: 45,
                  child: Tooltip(
                    message: '????????????????????? ?????????????????????????????????',
                    child: MyOutlineButton(
                      onPressed: () {
                        setState(() {
                          jobTypeValue = '??????????????? ????????????????????????';
                          locationValue = '??????????????????????????? ?????????????????????';
                          categoryValue = '??????????????? ???????????????????????????';
                          queryText = '';
                        });
                        searchForAds('');
                      },
                      borderColor: Theme.of(context).colorScheme.secondary,
                      child: Icon(
                        Icons.delete_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                  child: MyOutlineButton(
                    onPressed: () {
                      searchForAds(textFieldKey.currentState!.value);
                    },
                    borderColor: Theme.of(context).dividerColor,
                    child: const Text('???????????????'),
                  ),
                )
              ])
            ],
            GlobalKey());
      },
      label: Row(
        children: const [
          Text('???????????????'),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.search)
        ],
      ),
    );
  }

  Widget buildJumptoTopFab(BuildContext context) {
    return AnimatedOpacity(
      opacity: isFabVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: FloatingActionButton(
          heroTag: 'jumpToTop',
          tooltip: isFabVisible ? '??????????????? ???????????????????????????' : '',
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut);
            setState(() {
              isFabVisible = false;
            });
          },
          child: Icon(
            Icons.keyboard_arrow_up,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget buildErrorPage(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 36,
            ),
            const SizedBox(
              height: 15,
            ),
            Text('???????????????????????????????????? ????????? ????????????????????????!',
                style: GoogleFonts.notoSansGeorgian()),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                AndroidIntent intent = const AndroidIntent(
                  action: 'android.settings.WIFI_SETTINGS',
                );
                await intent.launch();
              },
              splashFactory: InkSparkle.splashFactory,
              splashColor:
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
              child: Ink(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '??????????????????????????? ????????????????????? ?????????????????????????????????',
                  style: GoogleFonts.notoSansGeorgian(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            SizedBox(
              height: 45,
              child: OutlinedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('?????? ?????????????????? ?????????????????????')),
            )
          ],
        ),
      ),
    );
  }

  var selectedFilter = ['', '', ''];

  AppBar buildAppBar() => AppBar(
        titleSpacing: 0,
        elevation: 3,
        title: Text(' ??????????????????????????????',
            style: GoogleFonts.notoSansGeorgian(
              fontSize: 16,
            )),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 1,
                child: Text("???????????????"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 1) {
              showAboutDialog(
                  context: context,
                  applicationName: '??????????????????????????????',
                  applicationIcon: SizedBox(
                      height: 52,
                      child: Image.asset('assets/icon/ic_launcher.png')),
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              '??????????????????????????????????????? ???????????????: ',
                            ),
                            InkWell(
                              onTap: () =>
                                  launchWebUrl(context, 'https://jobs.ge/'),
                              splashFactory: InkSparkle.splashFactory,
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .tertiary
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                              child: Ink(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Jobs.ge',
                                  style: GoogleFonts.notoSans(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => launchWebUrl(
                              context, 'https://github.com/MezzLasha/'),
                          splashFactory: InkSparkle.splashFactory,
                          splashColor: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                          child: Ink(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Lasha Mezvrishvili',
                              style: GoogleFonts.notoSans(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]);
            }
          }),
        ],
        bottom: (queryText != '' ||
                selectedFilter[0] != '??????????????? ???????????????????????????' ||
                selectedFilter[1] != '??????????????????????????? ?????????????????????' ||
                selectedFilter[2] != '??????????????? ????????????????????????')
            ? PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      if (queryText != '')
                        QueryFilterChip(
                          filterable: queryText,
                          title: queryText,
                          onSelected: () {
                            queryText = '';
                            searchForAdsFromMainScreen(queryText);
                          },
                        ),
                      if (selectedFilter[0] != '??????????????? ???????????????????????????')
                        QueryFilterChip(
                            title: selectedFilter[0],
                            filterable: selectedFilter[0],
                            onSelected: () {
                              categoryValue = '??????????????? ???????????????????????????';
                              searchForAdsFromMainScreen(queryText);
                            }),
                      if (selectedFilter[1] != '??????????????????????????? ?????????????????????')
                        QueryFilterChip(
                            title: selectedFilter[1],
                            filterable: selectedFilter[1],
                            onSelected: () {
                              locationValue = '??????????????????????????? ?????????????????????';
                              searchForAdsFromMainScreen(queryText);
                            }),
                      if (selectedFilter[2] != '??????????????? ????????????????????????')
                        QueryFilterChip(
                          title: jobTypeValue,
                          filterable: jobTypeValue,
                          onSelected: () {
                            jobTypeValue = '??????????????? ????????????????????????';
                            searchForAdsFromMainScreen(queryText);
                          },
                        ),
                      const SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                ))
            : const PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: SizedBox.shrink(),
              ),
      );

  final _scrollController = ScrollController();

  Widget buildPagedListView() {
    return PagedListView<int, Announcement>(
      pagingController: _pagingController,
      shrinkWrap: true,
      scrollController: _scrollController,
      builderDelegate: PagedChildBuilderDelegate<Announcement>(
        noItemsFoundIndicatorBuilder: (context) => Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
        newPageProgressIndicatorBuilder: (_) => const LinearProgressIndicator(),
        firstPageErrorIndicatorBuilder: (context) {
          return buildErrorPage(context);
        },
        newPageErrorIndicatorBuilder: (context) {
          return buildErrorPage(context);
        },
        noMoreItemsIndicatorBuilder: (context) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 200,
            margin: const EdgeInsets.only(bottom: 70),
            width: double.infinity,
            child: Center(
                child: Text(
              '???????????? ??????????????????????????? ????',
              style: GoogleFonts.notoSansGeorgian(fontSize: 20),
            )),
          );
        },
        itemBuilder: (context, item, index) => AdvertisementListWidget(
          item: item,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class AdvertisementListWidget extends StatelessWidget {
  final Announcement item;

  const AdvertisementListWidget({
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
                      const Text("???????????????"),
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
                  child: (context
                          .read<UserBloc>()
                          .state
                          .user
                          .savedAnnouncements
                          .contains(item))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("???????????????"),
                            Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("?????????????????????"),
                            Icon(
                              Icons.favorite_border,
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
                AdvertisementImage(
                  imageUrl: item.imageUrl,
                ),
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

class NavDrawerListTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final Function() onTap;

  const NavDrawerListTile({
    super.key,
    required this.selected,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thof = Theme.of(context);

    return ListTile(
      title: Text(
        title,
      ),
      horizontalTitleGap: 8,
      onTap: () => onTap(),
      selected: selected,
      splashColor: thof.colorScheme.tertiaryContainer,
      iconColor: thof.colorScheme.onSurfaceVariant,
      textColor: thof.colorScheme.onSurfaceVariant,
      selectedTileColor: thof.colorScheme.secondaryContainer,
      selectedColor: thof.colorScheme.onSecondaryContainer,
      shape: const StadiumBorder(),
      leading: Icon(
        icon,
      ),
    );
  }
}

class AttributeWidget extends StatelessWidget {
  final Announcement item;
  final bool? disableNewAttr;

  const AttributeWidget({Key? key, required this.item, this.disableNewAttr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (disableNewAttr == null || disableNewAttr == false)
          if (item.newAdvert)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 8),
              child: Tooltip(
                message: '??????????????? ????????????????????????',
                child: Icon(
                  Icons.fiber_new_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        if (item.aboutToExpire)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8),
            child: Tooltip(
              message: '???????????? ?????????????????? ????????????',
              child: Icon(
                Icons.timer_off_outlined,
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
            ),
          ),
        if (item.salary)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8),
            child: Tooltip(
              message: '??????????????????????????????',
              child: Text(
                '???',
                style: GoogleFonts.notoSansGeorgian(
                    color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          )
      ],
    );
  }
}

class ListTileSecondary extends StatelessWidget {
  final Announcement item;

  const ListTileSecondary({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.jobRegion != '' && item.jobProvider != '') {
      return Column(children: [
        const SizedBox(
          height: 12,
        ),
        AutoSizeText(
          '${item.jobProvider} ?? ${item.jobRegion}',
          maxLines: 2,
          style: GoogleFonts.notoSansGeorgian(
              color: Color.lerp(Theme.of(context).disabledColor,
                  Theme.of(context).colorScheme.primary, 0.7)),
        ),
      ]);
    } else if (item.jobRegion == '' && item.jobProvider != '') {
      return Column(children: [
        const SizedBox(
          height: 12,
        ),
        AutoSizeText(
          item.jobProvider,
          maxLines: 2,
          style: GoogleFonts.notoSansGeorgian(
              color: Color.lerp(Theme.of(context).disabledColor,
                  Theme.of(context).colorScheme.primary, 0.7)),
        ),
      ]);
    } else if (item.jobRegion != '' && item.jobProvider == '') {
      return Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            item.jobProvider,
            maxLines: 2,
            style: GoogleFonts.notoSansGeorgian(
                color: Color.lerp(Theme.of(context).disabledColor,
                    Theme.of(context).colorScheme.primary, 0.7)),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}

class QueryFilterChip extends StatelessWidget {
  final String title;
  final String filterable;
  final Function() onSelected;
  const QueryFilterChip(
      {super.key,
      required this.title,
      required this.filterable,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
      ),
      child: FilterChip(
        label: Row(
          children: [
            Icon(
              Icons.close,
              size: 17,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: GoogleFonts.notoSansGeorgian(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        selectedColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        selected: true,
        showCheckmark: false,
        onSelected: (value) {
          onSelected();
        },
      ),
    );
  }
}
