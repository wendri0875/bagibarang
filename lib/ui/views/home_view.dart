import 'dart:ui';

import 'package:bagi_barang/models/billable.dart';
import 'package:bagi_barang/services/authentication.dart';
import 'package:bagi_barang/ui/widgets/billables.dart';

import 'package:bagi_barang/viewmodels/home_view_model.dart';
import 'package:bagi_barang/ui/widgets/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

//void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Bagi Barang',
//       theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.

//           fontFamily: 'FuturaLight',
//           primarySwatch: Colors.green),
//       home: MyHomePage(title: 'BAGI BARANG'),
//     );
//   }
// }

class HomeView extends StatelessWidget {
  // HomeView({Key key,// this.title, this.auth, this.user, this.logoutCallback
  // })
  //     : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;
  // final BaseAuth auth;
  // final VoidCallback logoutCallback;
  // final FirebaseUser user;

  // @override
  // _HomePageState createState() => _HomePageState();
//}

//class _HomePageState extends State<HomeView> {
//  int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //   //  _counter++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    String title;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) title = arguments['title'];

    return ViewModelProvider<HomeViewModel>.withConsumer(
      viewModel: HomeViewModel(),
      // onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,
              ),
              child: sideNav(context, model)),
          appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              iconTheme: new IconThemeData(color: Colors.black),
              bottom: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.shopping_cart)),
                  Tab(icon: Icon(Icons.local_shipping)),
                ],
              ),
              title: Text(title,
                  style: TextStyle(fontFamily: 'MB', color: Colors.black)),
              backgroundColor: Colors.white),
          body: TabBarView(
            children: [
              Products(),
              // Center(
              //   // Center is a layout widget. It takes a single child and positions it
              //   // in the middle of the parent.
              //   child: Column(
              //     // Column is also a layout widget. It takes a list of children and
              //     // arranges them vertically. By default, it sizes itself to fit its
              //     // children horizontally, and tries to be as tall as its parent.
              //     //
              //     // Invoke "debug painting" (press "p" in the console, choose the
              //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
              //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              //     // to see the wireframe for each widget.
              //     //
              //     // Column has various properties to control how it sizes itself and
              //     // how it positions its children. Here we use mainAxisAlignment to
              //     // center the children vertically; the main axis here is the vertical
              //     // axis because Columns are vertical (the cross axis would be
              //     // horizontal).
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Text(
              //         'You have pushed the button this many times:',
              //       ),
              //       Text(
              //         '$_counter',
              //         style: Theme.of(context).textTheme.headline4,
              //       ),
              //     ],
              //   ),
              // ),
              // // This trailing comma makes auto-formatting nicer for build methods.

              Billables(),
              Icon(Icons.directions_bike),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            //onPressed: _incrementCounter,
            onPressed: () {

              model.navigateToAddProduct();
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Drawer sideNav(BuildContext context, HomeViewModel model) {
    return Drawer(
      child: Stack(children: <Widget>[
        //first child be the blur background
        BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY: 5.0), //this is dependent on the import statment above
            child: Container(
                decoration:
                    BoxDecoration(color: Colors.white.withOpacity(0.5)))),
        new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                    Colors.green,
                    Colors.teal[900],
                  ])),
              accountEmail: new Text(model.currentFirebaseUser.email),
              accountName: new Text(model.currentFirebaseUser.displayName),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                    backgroundImage: new NetworkImage(
                  model.currentFirebaseUser.photoUrl,
                )
                    // "https://yt3.ggpht.com/a-/AOh14GjOA59oi_I9tSCzIfgFcPQdBiMp7JyITQNcRhU7aA=s88-c-k-c0xffffffff-no-rj-mo"),
                    ),
                onTap: () => print("This is your current account."),
              ),
              // otherAccountsPictures: <Widget>[
              //   new GestureDetector(
              //     child: new CircleAvatar(
              //       backgroundImage: new NetworkImage(otherProfilePic),
              //     ),
              //     onTap: () => switchAccounts(),
              //   ),
              // ],
              // decoration: new BoxDecoration(
              //   image: new DecorationImage(
              //     image: new NetworkImage("https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
              //     fit: BoxFit.fill
              //  )
              // ),
            ),
            new ListTile(
                title:
                    new Text("Page One", style: TextStyle(color: Colors.white)),
                trailing: new Icon(Icons.arrow_upward, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                  //  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("First Page")));
                }),
            new ListTile(
                title:
                    new Text("Page Two", style: TextStyle(color: Colors.white)),
                trailing: new Icon(Icons.arrow_right, color: Colors.white),
                onTap: () {
                  Navigator.of(context).pop();
                  //  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Page("Second Page")));
                }),
            new Divider(
              color: Colors.white,
            ),
            new ListTile(
              title: new Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              trailing: new Icon(Icons.cancel, color: Colors.white),
              //onTap: () => Navigator.pop(context),
              onTap: () => model.logout(),
            ),
          ],
        ),
      ]),
    );
  }
}
