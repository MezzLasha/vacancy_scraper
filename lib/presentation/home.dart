import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/myCustomWidgets.dart';
import 'package:vacancy_scraper/presentation/advertScreen.dart';
import 'package:vacancy_scraper/repositories/databaseRepo.dart';

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

  // List of items in our dropdown menu
  var category = [
    'ყველა კატეგორია',
    'ადმინისტრაცია/მენეჯმენტი',
    'ფინანსები/სტატისტიკა',
    'გაყიდვები',
    'PR/მარკეტინგი',
    'ზოგადი ტექნიკური პერსონალი',
    'ლოგისტიკა/ტრანსპორტი/დისტრიბუცია',
    'მშენებლობა/რემონტი',
    'დასუფთავება',
    'დაცვა/უსაფრთხოება',
    'IT/პროგრამირება',
    'მედია/გამომცემლობა',
    'განათლება',
    'სამართალი',
    'მედიცინა/ფარმაცია',
    'სილამაზე/მოდა',
    'კვება',
    'სხვა',
  ];

  var location = [
    'ნებისმიერ ადგილას',
    'თბილისი',
    'აფხაზეთის ა/რ',
    'აჭარის ა/რ',
    'გურია',
    'იმერეთი',
    'კახეთი',
    'მცხეთა-მთიანეთი',
    'რაჭა-ლეჩხუმი, ქვ. სვანეთი',
    'სამეგრელო-ზემო სვანეთი',
    'სამცხე-ჯავახეთი',
    'ქვემო ქართლი',
    'შიდა ქართლი',
    'უცხოეთი',
    'დისტანციური',
  ];

  var jobType = [
    'ყველა ვაკანსია',
    'ვაკანსიები',
    'სტიპენდიები',
    'სხვა',
    'ტენდერები',
    'ტრენინგები',
  ];

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
    await _fetchPage(0);
  }

  Future<void> searchForAdsFromMainScreen(String filterString) async {
    updateFilterValues();
    setFilter(
        filterString, selectedFilter[0], selectedFilter[1], selectedFilter[2]);
    _pagingController.itemList = [];
    await _fetchPage(0);
  }

  var textFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedOpacity(
            opacity: isFabVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: FloatingActionButton(
                child: const Icon(Icons.keyboard_arrow_up),
                onPressed: () {
                  _scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                  setState(() {
                    isFabVisible = false;
                  });
                },
              ),
            ),
          ),
          FloatingActionButton.extended(
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 45,
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
                              borderColor: Theme.of(context).dividerColor,
                              child: const Icon(Icons.undo),
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
          ),
        ],
      ),
      appBar: buildAppBar(),
      body: RefreshIndicator(onRefresh: _refresh, child: buildPagedListView()),
    );
  }

  var selectedFilter = ['', '', ''];

  AppBar buildAppBar() => AppBar(
        title: const Text('Vacancy Scraper'),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 8.0),
                          child: FilterChip(
                            label: Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  queryText,
                                  style: GoogleFonts.notoSansGeorgian(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            selected: true,
                            showCheckmark: false,
                            onSelected: (value) {
                              queryText = '';
                              searchForAdsFromMainScreen(queryText);
                            },
                          ),
                        ),
                      if (selectedFilter[0] != 'ყველა კატეგორია')
                        Padding(
                          padding: EdgeInsets.only(
                              left: queryText != '' ? 0 : 12, right: 8.0),
                          child: FilterChip(
                            label: Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  selectedFilter[0],
                                  style: GoogleFonts.notoSansGeorgian(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            selected: true,
                            showCheckmark: false,
                            onSelected: (value) {
                              categoryValue = 'ყველა კატეგორია';
                              searchForAdsFromMainScreen(queryText);
                            },
                          ),
                        ),
                      if (selectedFilter[1] != 'ნებისმიერ ადგილას')
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  selectedFilter[1],
                                  style: GoogleFonts.notoSansGeorgian(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            selected: true,
                            showCheckmark: false,
                            onSelected: (value) {
                              locationValue = 'ნებისმიერ ადგილას';
                              searchForAdsFromMainScreen(queryText);
                            },
                          ),
                        ),
                      if (selectedFilter[2] != 'ყველა ვაკანსია')
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Row(
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 17,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  selectedFilter[2],
                                  style: GoogleFonts.notoSansGeorgian(
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 0),
                            selected: true,
                            showCheckmark: false,
                            onSelected: (value) {
                              jobTypeValue = 'ყველა ვაკანსია';
                              searchForAdsFromMainScreen(queryText);
                            },
                          ),
                        ),
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
        itemBuilder: (context, item, index) => OpenContainer(
          closedColor: Theme.of(context).canvasColor,
          closedElevation: 0,
          middleColor: Theme.of(context).canvasColor,
          openColor: Theme.of(context).canvasColor,
          closedShape: const Border(),
          closedBuilder: (context, tap) {
            return InkWell(
              onTap: () => tap(),
              child: Ink(
                padding: const EdgeInsets.only(left: 16, right: 16),
                height: 70,
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
                      fit: FlexFit.loose,
                      child: Text(
                        item.jobName,
                        style: GoogleFonts.notoSansGeorgian(),
                      ),
                    ),
                    adBlurBanner(item.imageUrl),
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

Widget adBlurBanner(String imageUrl) {
  if (imageUrl != '/i/pix.gif') {
    return Image.network(
      'https://jobs.ge$imageUrl',
    );
  } else {
    return const SizedBox.shrink();
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: BlocConsumer<DatabaseBloc, DatabaseState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         if (state.listOfAds.isEmpty && state.status == DbStatus.empty) {
//           context.read<DatabaseBloc>().add(DatabaseLoadHome());
//         }

//         if (state.status == DbStatus.loading) {
//           return const LinearProgressIndicator();
//         }
//         return RefreshIndicator(
//           onRefresh: (() {
//             context.read<DatabaseBloc>().add(DatabaseRefresh());
//             return Future.value(null);
//           }),
//           child: ListView.builder(
//             itemCount: state.listOfAds.length,
//             itemBuilder: (context, index) {
//               return OpenContainer(
//                 transitionType: ContainerTransitionType.fade,
//                 closedElevation: 0,
//                 closedBuilder: (context, tap) {
//                   return InkWell(
//                     onTap: () => tap(),
//                     child: Ink(
//                       padding: const EdgeInsets.only(left: 16),
//                       height: 56,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Flexible(
//                             fit: FlexFit.loose,
//                             child: Text(
//                               state.listOfAds[index].jobName,
//                               style: GoogleFonts.notoSansGeorgian(),
//                             ),
//                           ),
//                           adBlurBanner(state.listOfAds[index].imageUrl),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 openBuilder: (context, action) {
//                   return AdvertScreen(announcement: state.listOfAds[index]);
//                 },
//               );
//             },
//           ),
//         );
//       },
//     ),
//   );
// }
