// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:phases/pages/about.dart';
import 'package:flutter/services.dart';
import 'package:phases/pages/loading.dart';
import 'package:phases/tabs.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async
{
  Crashlytics.instance.enableInDevMode = false;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/' : (context) => Loading(),
      '/tabs' : (context) => TabPage(),
      '/about': (context) => About(),
    },

  ));
}

