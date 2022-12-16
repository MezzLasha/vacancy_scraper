import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:vacancy_scraper/presentation/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vacancy_scraper/repositories/fireRepo.dart';

import 'bloc/user_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

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
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      var lightTheme = ThemeData(
        fontFamily: GoogleFonts.notoSansGeorgian().fontFamily,
        pageTransitionsTheme: getPageTransitionsTheme(),
        useMaterial3: true,
      );

      var darkTheme = ThemeData.dark(
        useMaterial3: true,
      );

      if (lightDynamic != null) {
        lightTheme = ThemeData(
          colorScheme: lightDynamic,
          fontFamily: GoogleFonts.notoSansGeorgian().fontFamily,
          pageTransitionsTheme: getPageTransitionsTheme(),
          useMaterial3: true,
        );
      }

      if (darkDynamic != null) {
        darkTheme = ThemeData(
          colorScheme: darkDynamic,
          pageTransitionsTheme: getPageTransitionsTheme(),
          fontFamily: GoogleFonts.notoSansGeorgian().fontFamily,
          useMaterial3: true,
        );
      }

      return RepositoryProvider(
        create: (context) => FireRepository(),
        child: BlocProvider(
          create: (context) => UserBloc(
            RepositoryProvider.of<FireRepository>(context),
          ),
          child: MaterialApp(
            themeAnimationCurve: Curves.easeInOutCubicEmphasized,
            themeAnimationDuration: const Duration(milliseconds: 500),
            debugShowCheckedModeBanner: false,
            scrollBehavior: MyCustomScrollBehavior(),
            title: 'ვაკანსიები',
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const HomeScreen(),
          ),
        ),
      );
    });
  }

  PageTransitionsTheme getPageTransitionsTheme() {
    return const PageTransitionsTheme(builders: {
      TargetPlatform.android: SharedAxisPageTransitionsBuilder(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
      TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
        transitionType: SharedAxisTransitionType.horizontal,
      ),
    });
  }
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}
