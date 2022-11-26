import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vacancy_scraper/presentation/home.dart';

// Fictitious brand color.
final _defaultLightColorScheme =
    ColorScheme.fromSwatch(primarySwatch: Colors.blue);

final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, brightness: Brightness.dark);
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
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      // ColorScheme lightColorScheme;
      // ColorScheme darkColorScheme;

      // if (lightDynamic != null && darkDynamic != null) {
      //   // On Android S+ devices, use the provided dynamic color scheme.
      //   // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
      //   lightColorScheme = lightDynamic.harmonized();
      //   // (Optional) Customize the scheme as desired. For example, one might
      //   // want to use a brand color to override the dynamic [ColorScheme.secondary].
      //   lightColorScheme = lightColorScheme.copyWith(secondary: _brandBlue);
      //   // (Optional) If applicable, harmonize custom colors.
      //   lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

      //   // Repeat for the dark color scheme.
      //   darkColorScheme = darkDynamic.harmonized();
      //   darkColorScheme = darkColorScheme.copyWith(secondary: _brandBlue);
      //   darkCustomColors = darkCustomColors.harmonized(darkColorScheme);

      //   _isDemoUsingDynamicColors = true; // ignore, only for demo purposes
      // } else {
      //   // Otherwise, use fallback schemes.
      //   lightColorScheme = ColorScheme.fromSeed(
      //     seedColor: _brandBlue,
      //   );
      //   darkColorScheme = ColorScheme.fromSeed(
      //     seedColor: _brandBlue,
      //     brightness: Brightness.dark,
      //   );
      // }

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'ვაკანსიები',
        theme: ThemeData(
          colorScheme: lightDynamic ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      );
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
