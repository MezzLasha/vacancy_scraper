import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/database/bloc/database_bloc.dart';
import 'package:vacancy_scraper/presentation/home.dart';

import 'repositories/databaseRepo.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseRepository(),
      child: BlocProvider(
        create: (context) =>
            DatabaseBloc(RepositoryProvider.of<DatabaseRepository>(context)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: MyCustomScrollBehavior(),
          title: 'ვაკანსიები',
          theme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.notoSansGeorgianTextTheme()),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
