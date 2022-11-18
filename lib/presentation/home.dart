import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      print('refreshing');
      final newItems =
          await DatabaseRepository().fetchAnnouncements(pageKey, _pageSize);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showMyBottomDialog(
              context,
              [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'საძიებო სიტყვა',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 40,
                    child: MyOutlineButton(
                      onPressed: () {},
                      borderColor: Theme.of(context).primaryColor,
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
            Icon(Iconsax.search_normal)
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: (() => _refresh()),
        child: PagedListView<int, Announcement>(
          pagingController: _pagingController,
          shrinkWrap: true,
          builderDelegate: PagedChildBuilderDelegate<Announcement>(
            noItemsFoundIndicatorBuilder: (context) => Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
            ),
            itemBuilder: (context, item, index) => OpenContainer(
              transitionType: ContainerTransitionType.fade,
              closedElevation: 0,
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
