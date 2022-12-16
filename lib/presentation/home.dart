import 'package:android_intent_plus/android_intent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vacancy_scraper/auth/login_screen.dart';
import 'package:vacancy_scraper/auth/register_screen.dart';
import 'package:vacancy_scraper/custom/myOpenContainer.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';
import 'package:vacancy_scraper/presentation/advertScreen.dart';
import 'package:vacancy_scraper/presentation/savedAdverts.dart';
import 'package:vacancy_scraper/presentation/settings.dart';
import 'package:vacancy_scraper/repositories/databaseRepo.dart';

import '../bloc/user_bloc.dart';
import '../models/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageSize = 300;

  final PagingController<int, Announcement> _pagingController =
      PagingController(firstPageKey: 1);

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
    refreshGlobalKey.currentState!.show();
    _pagingController.itemList = [];
    try {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    } catch (_) {}
    await _fetchPage(0);
  }

  void setFilter(
      String filterString, String category, String location, String jobType) {
    String cid = '';
    String lid = '';
    String jid = '';

    switch (category) {
      case 'ყველა კატეგორია':
        cid = '';
        break;
      case 'ადმინისტრაცია/მენეჯმენტი':
        cid = '1';
        break;
      case 'ფინანსები/სტატისტიკა':
        cid = '3';
        break;
      case 'გაყიდვები':
        cid = '2';
        break;
      case 'PR/მარკეტინგი':
        cid = '4';
        break;
      case 'ზოგადი ტექნიკური პერსონალი':
        cid = '18';
        break;
      case 'ლოგისტიკა/ტრანსპორტი/დისტრიბუცია':
        cid = '5';
        break;
      case 'მშენებლობა/რემონტი':
        cid = '11';
        break;
      case 'დასუფთავება':
        cid = '16';
        break;
      case 'დაცვა/უსაფრთხოება':
        cid = '17';
        break;
      case 'IT/პროგრამირება':
        cid = '6';
        break;
      case 'მედია/გამომცემლობა':
        cid = '13';
        break;
      case 'განათლება':
        cid = '12';
        break;
      case 'სამართალი':
        cid = '7';
        break;
      case 'მედიცინა/ფარმაცია':
        cid = '8';
        break;
      case 'სილამაზე/მოდა':
        cid = '14';
        break;
      case 'კვება':
        cid = '10';
        break;
      case 'სხვა':
        cid = '9';
        break;

      default:
        '';
    }

    switch (location) {
      case 'ნებისმიერ ადგილას':
        lid = '';
        break;
      case 'თბილისი':
        lid = '1';
        break;
      case 'აფხაზეთის ა/რ':
        lid = '15';
        break;
      case 'აჭარის ა/რ':
        lid = '14';
        break;
      case 'გურია':
        lid = '9';
        break;
      case 'იმერეთი':
        lid = '8';
        break;
      case 'კახეთი':
        lid = '3';
        break;
      case 'მცხეთა-მთიანეთი':
        lid = '4';
        break;
      case 'რაჭა-ლეჩხუმი, ქვ. სვანეთი':
        lid = '12';
        break;
      case 'სამეგრელო-ზემო სვანეთი':
        lid = '13';
        break;
      case 'სამცხე-ჯავახეთი':
        lid = '7';
        break;
      case 'ქვემო ქართლი':
        lid = '5';
        break;
      case 'შიდა ქართლი':
        lid = '6';
        break;
      case 'უცხოეთი':
        lid = '16';
        break;
      case 'დისტანციური':
        lid = '17';
        break;

      default:
        '';
    }

    switch (jobType) {
      case 'ყველა ვაკანსია':
        jid = '';
        break;
      case 'ვაკანსიები':
        jid = '1';
        break;
      case 'სტიპენდიები':
        jid = '2';
        break;
      case 'სხვა':
        jid = '5';
        break;
      case 'ტენდერები':
        jid = '4';
        break;
      case 'ტრენინგები':
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

  String categoryValue = 'ყველა კატეგორია';
  String locationValue = 'ნებისმიერ ადგილას';
  String jobTypeValue = 'ყველა ვაკანსია';

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

  final userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => userBloc,
      child: Scaffold(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        var loggedOut = state.user == UserInitial().user;

                        return AnimatedCrossFade(
                            firstChild: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LoginScreen(homeBloc: userBloc),
                                        ));
                                  },
                                  label: const Text('შესვლა'),
                                  icon: const Icon(
                                    Icons.person,
                                    size: 24,
                                  ),
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
                                  state.user.name,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  state.user.jobCategory,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            crossFadeState: loggedOut
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            sizeCurve: Curves.easeInOutCubicEmphasized,
                            duration: const Duration(milliseconds: 400));
                      },
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
                      title: 'ვაკანსიები',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    NavDrawerListTile(
                        selected: false,
                        icon: Icons.favorite_outline,
                        title: 'დამახსოვრებული',
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedAdverts(),
                              ));
                        }),
                    NavDrawerListTile(
                      selected: false,
                      icon: Icons.translate,
                      title: 'პარამეტრები',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state.user == UserInitial().user) {
                return const SizedBox.shrink();
              }

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FilledButton.tonalIcon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('უკან')),
                                TextButton(
                                    onPressed: () {
                                      userBloc.add(LogoutUser());
                                      Navigator.pop(context);
                                    },
                                    child: const Text('კი')),
                              ],
                              title: const Text('ანგარიშიდან გასვლა'),
                              alignment: Alignment.center,
                              content: const Text(
                                  'ნამდვილად გსურთ ანგარიშიდან გამოსვლა?'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout_outlined),
                        label: const Text('გასვლა')),
                  ),
                ),
              );
            },
          )
        ]),
        appBar: buildAppBar(),
        body: RefreshIndicator(
            key: refreshGlobalKey,
            onRefresh: _refresh,
            child: buildPagedListView()),
      ),
    );
  }

  FloatingActionButton buildSearchFab(BuildContext context) {
    return FloatingActionButton.extended(
      tooltip: 'საძიებო ფილტრები',
      onPressed: () {
        showMyBottomDialog(
            context,
            [
              TextFormField(
                key: textFieldKey,
                initialValue: queryText,
                decoration: InputDecoration(
                    labelText: 'საძიებო სიტყვა',
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
                      labelText: 'კატეგორია',
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
                      labelText: 'ლოკაცია',
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
                      labelText: 'ვაკანსიის ტიპი',
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
                    message: 'ფილტრის გასუფთავება',
                    child: MyOutlineButton(
                      onPressed: () {
                        setState(() {
                          jobTypeValue = 'ყველა ვაკანსია';
                          locationValue = 'ნებისმიერ ადგილას';
                          categoryValue = 'ყველა კატეგორია';
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
                    child: const Text('ძებნა'),
                  ),
                )
              ])
            ],
            GlobalKey());
      },
      label: Row(
        children: const [
          Text('ძებნა'),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.search)
        ],
      ),
    );
  }

  AnimatedOpacity buildJumptoTopFab(BuildContext context) {
    return AnimatedOpacity(
      opacity: isFabVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: FloatingActionButton(
          heroTag: 'jumpToTop',
          tooltip: isFabVisible ? 'მაღლა დაბრუნება' : '',
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
            Text('განცხადებები ვერ მოიძებნა!',
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
                  'შეამოწმეთ კავშირი ინტერნეტთან',
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
                  label: const Text('ან სცადეთ ახლიდან')),
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
        title: Text(' ვაკანსიები',
            style: GoogleFonts.notoSansGeorgian(
              fontSize: 16,
            )),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 1,
                child: Text("წყარო"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 1) {
              showAboutDialog(
                  context: context,
                  applicationName: 'ვაკანსიები',
                  applicationIcon: SizedBox(
                      height: 52,
                      child: Image.asset('assets/icon/ic_launcher.png')),
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'განცხადებების წყარო: ',
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
                selectedFilter[0] != 'ყველა კატეგორია' ||
                selectedFilter[1] != 'ნებისმიერ ადგილას' ||
                selectedFilter[2] != 'ყველა ვაკანსია')
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
                      if (selectedFilter[0] != 'ყველა კატეგორია')
                        QueryFilterChip(
                            title: selectedFilter[0],
                            filterable: selectedFilter[0],
                            onSelected: () {
                              categoryValue = 'ყველა კატეგორია';
                              searchForAdsFromMainScreen(queryText);
                            }),
                      if (selectedFilter[1] != 'ნებისმიერ ადგილას')
                        QueryFilterChip(
                            title: selectedFilter[1],
                            filterable: selectedFilter[1],
                            onSelected: () {
                              locationValue = 'ნებისმიერ ადგილას';
                              searchForAdsFromMainScreen(queryText);
                            }),
                      if (selectedFilter[2] != 'ყველა ვაკანსია')
                        QueryFilterChip(
                          title: jobTypeValue,
                          filterable: jobTypeValue,
                          onSelected: () {
                            jobTypeValue = 'ყველა ვაკანსია';
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
  var _tapDownPosition;

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
              'სიის დასასრული 📝',
              style: GoogleFonts.notoSansGeorgian(fontSize: 20),
            )),
          );
        },
        itemBuilder: (context, item, index) => MyOpenContainer(
          closedColor: Theme.of(context).colorScheme.background,
          closedElevation: 0,
          middleColor: Theme.of(context).colorScheme.background,
          transitionType: MyOpenContainerTransitionType.fadeThrough,
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
      title: Text(title),
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

  const AttributeWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (item.newAdvert)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8),
            child: Tooltip(
              message: 'ახალი დადებული',
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
              message: 'ვადა გასდის მალე',
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
              message: 'ხელფასიანი',
              child: Text(
                '₾',
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
          '${item.jobProvider} · ${item.jobRegion}',
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
