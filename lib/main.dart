import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/pages/root_page.dart';
import 'package:bagi_barang/provider/priceprovider.dart';
import 'package:bagi_barang/provider/totalorderprovider.dart';
import 'package:bagi_barang/provider/varianprovider.dart';
import 'package:bagi_barang/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/weightprovider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null; //this
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
           //  Provider<VarianProvider>(create: (_) => VarianProvider()),
              Provider<TotalOrderProvider>(create: (_) => TotalOrderProvider()),
         //     Provider<PriceProvider>(create: (_) => PriceProvider()),
           //   Provider<WeightProvider>(create: (_) => WeightProvider()),
          //    ChangeNotifierProvider(create: (_) => VarianProvider()),
          //     ChangeNotifierProvider(create: (_) => PriceProvider()),
          //     ChangeNotifierProvider(create: (_) => WeightProvider()),
          ],
          child: new MaterialApp(
          title: 'Flutter login demo',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            fontFamily: 'FuturaLight',
            primarySwatch: Colors.green,
          ),
          home: new RootPage(auth: new Auth())),
    );
  }
}
