import 'dart:async';

import 'package:bagi_barang/provider/priceprovider.dart';
import 'package:bagi_barang/provider/varianprovider.dart';
import 'package:bagi_barang/provider/weightprovider.dart';
import 'package:bagi_barang/ui/widgets/orders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:bagi_barang/pages/orders.dart';
import 'dart:ui';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:provider/provider.dart';

class VarianDetail extends StatefulWidget {
  Product product;
  Variant varian;

  VarianDetail(
    this.product,
    this.varian, {
    Key key,
  }) : super(key: key);

  @override
  _VarianDetailState createState() => _VarianDetailState();
}

class _VarianDetailState extends State<VarianDetail> {
  // var price = 0;
  // var weight = 0;

  @override
  void initState() {
    StreamSubscription _subscription;
    String path = 'companies/Al-Hayya/Products/' +
        widget.product.idprod +
        '/Variant/' +
        widget.varian.label;

    _subscription = Firestore.instance
        .document(path)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      // pricepvd.price = snapshot.data['price'];
      //  weightpvd.weight = snapshot.data['weight'];
      setState(() {
        // weight = snapshot.data['weight'];
        //  price = snapshot.data['price'];

        // widget.varian.weight = snapshot.data['weight'];
        // widget.varian.price = snapshot.data['price'];
        widget.varian = Variant.fromSnapshot(snapshot);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var pricepvd = Provider.of<PriceProvider>(context);
    //  var weightpvd = Provider.of<WeightProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Container(
        height: MediaQuery.of(context).copyWith().size.height * 0.95,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0)),
                      color: Colors.white.withOpacity(0.6))),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.maximize,
                  color: Colors.white38,
                  size: 40,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product.pname.toUpperCase(),
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "MB",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Varian",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(widget.varian.label,
                                    style: TextStyle(fontSize: 15))
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Price",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                // Consumer<PriceProvider>(
                                //   builder:
                                //       (BuildContext context, pricepvd, _) {
                                //     return
                                Text(
                                  //      pricepvd.price.toString(),
                                  //       varianpfd.price.toString(),
                                  //  "",
                                  widget.varian.price.toString(),
                                  style: TextStyle(fontSize: 15),
                                  //  );
                                  //},
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Weight",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                //Consumer<WeightProvider>(builder:
                                // (BuildContext context, weightpvd, _) {
                                //  return
                                Text(
                                  // "",
                                  //  weightpvd.weight.toString(),
                                  // weightpvd1.weight.toString(),
                                  widget.varian.weight.toString(),
                                  style: TextStyle(fontSize: 15),
                                  //     );
                                  //    }
                                )
                              ],
                            ),
                          ])
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: new TabBar(
                    // indicatorColor: Colors.pink,
                    //   indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.symmetric(vertical: 5),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black38,
                    labelStyle: TextStyle(
                        fontSize: 15,
                        fontFamily: "MB",
                        fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                        text: 'ORDERS',
                      ),
                      Tab(
                        text: 'STOCK',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Center(
                        //  child: Text('data'),
                        //child: Container(
                        child: Orders(
                         // idprod: widget.product.idprod,
                         // varian: widget.varian,
                        ),
                        //),
                      ),
                      Center(child: Text('Stock')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
