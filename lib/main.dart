import 'package:bagi_barang/services/dialog_service.dart';
import 'package:bagi_barang/services/navigation_service.dart';
import 'package:bagi_barang/ui/router.dart';
import 'package:flutter/material.dart';

import 'locator.dart';
import 'managers/dialog_manager.dart';

import 'ui/views/startup_view.dart';

void main() {
  // Register all the models and services before the app starts
  setupLocator();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bagi Barang',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => DialogManager(child: child)),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          fontFamily: 'FuturaLight',
          primarySwatch: Colors.green,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          //   backgroundColor: Color.fromARGB(255, 26, 27, 30),
          backgroundColor: Colors.white),
      //  home: new RootPage(auth: new Auth()));
      home: StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
