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
  static const _pageSize = 20;

  final PagingController<int, Announcement> _pagingController =
      PagingController(firstPageKey: 1);

  var isFabVisible = false;
  String filter =
      '&q=&cid=0&lid=0&jid=0&in_title=0&has_salary=0&is_ge=0&for_scroll=yes';
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
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print('refreshing');
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

  Future<void> searchForAds() async {
    _pagingController.itemList = [];
    await _fetchPage(0);

    Navigator.pop(context);
  }

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
                        style: GoogleFonts.notoSansGeorgian().copyWith(
                            overflow: TextOverflow.ellipsis, fontSize: 15),
                        decoration: InputDecoration(
                            labelText: 'კატეგორია',
                            labelStyle: GoogleFonts.notoSansGeorgian().copyWith(
                                overflow: TextOverflow.ellipsis, fontSize: 15),
                            helperMaxLines: 1,
                            border: const OutlineInputBorder()),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 45,
                        child: MyOutlineButton(
                          onPressed: () {
                            searchForAds();
                          },
                          borderColor: Theme.of(context).dividerColor,
                          child: const Text('ძებნა'),
                        ),
                      ),
                    )
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
      appBar: AppBar(title: const Text('Vacancy Scraper')),
      body: RefreshIndicator(onRefresh: _refresh, child: buildPagedListView()),
    );
  }

  final _scrollController = ScrollController();

  Widget buildPagedListView() {
    return PagedListView<int, Announcement>(
      pagingController: _pagingController,
      shrinkWrap: true,
      scrollController: _scrollController,
      builderDelegate: PagedChildBuilderDelegate<Announcement>(
        noItemsFoundIndicatorBuilder: (context) => Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
        ),
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
                height: 56,
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
