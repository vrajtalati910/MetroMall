import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:tailor_mate/injector/injector.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> bootstrap(Widget builder) async {
  Zone.current.fork().runGuarded(() async {
    // Remove # from the URL
    setPathUrlStrategy();

    if (!kIsWeb) {
      HttpOverrides.global = MyHttpOverrides();
    }

    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(
      kIsWeb
          ? FlutterWebFrame(
              maximumSize: const Size(414, 896),
              enabled: true,
              builder: (context) => builder,
            )
          : builder,
    );

    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    };
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
