import 'package:flutter/material.dart';
import 'package:tailor_mate/core/theme/app_theme.dart' as AppTheme;
import 'package:tailor_mate/splash/splash_page.dart';
import 'package:tailor_mate/view/app_wrapper.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child: MaterialApp(
        title: 'Tailor Mate',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
