// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/database/bloc/database_bloc.dart';

import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/repositories/databaseRepo.dart';

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

  @override
  void initState() {
    future = DatabaseRepository().getDetailedAd(widget.announcement);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.announcement.jobName,
              style: GoogleFonts.notoSansGeorgian(fontSize: 17)),
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return SingleChildScrollView(
                child: Html(
                  data: snapshot.data!.description,
                ),
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        ));
  }
}
