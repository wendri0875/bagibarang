

import 'dart:ui';

import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/models/variant.dart';
import 'package:bagi_barang/pages/variandetail.dart';

import 'package:bagi_barang/widgets/circularButton.dart';
import 'package:bagi_barang/widgets/productColorSelector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grid_selector/base_grid_selector_item.dart';
import 'package:grid_selector/grid_selector.dart';
import 'package:grid_selector/grid_selector_item.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';



class ProductDetail extends StatefulWidget {
  final Product product;
  // final idprod;
  // final prodName;
  final imageFile;
  ProductDetail({this.product, this.imageFile});

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  double rating = 4.0;

  final String desc =
      "Maxwell sole construction delivers exceptional durability and is resistant to oil,"
      "fat, acid, petrol and alkali; air-cushioned honeycomb";

  //create controller untuk tabBar
  TabController controller;

  @override
  void initState() {
    // _getVariant();
    SystemChrome.setEnabledSystemUIOverlays([]);

    //tambahkan SingleTickerProviderStateMikin pada class _HomeState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      backgroundColor: Color(0xFFf9f9f7),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.product.idprod,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 73),
              child: Image.memory(
                widget.imageFile,
                width: double.infinity,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFdad9d5),
                  Color(0xFFdcd9d2).withOpacity(0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 0.5],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: ScreenUtil().setHeight(480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product.pname.toUpperCase(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(54),
                        fontFamily: "MB",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     ConstrainedBox(
                    //       constraints: BoxConstraints(
                    //         maxWidth: ScreenUtil().setWidth(400),
                    //       ),
                    //       child: Text(
                    //         widget.prodName.toUpperCase(),
                    //         style: TextStyle(
                    //           fontSize: ScreenUtil().setSp(54),
                    //           fontFamily: "MB",
                    //           fontWeight: FontWeight.w700,
                    //         ),
                    //       ),
                    //     ),
                    //     // Column(
                    //     //   crossAxisAlignment: CrossAxisAlignment.end,
                    //     //   children: <Widget>[
                    //     //     CustomPaint(
                    //     //       painter: LinePainter(),
                    //     //       child: Text("\$239",
                    //     //           style: TextStyle(
                    //     //             fontSize: ScreenUtil().setSp(34),
                    //     //           //  fontFamily: "Montserrat",
                    //     //             fontWeight: FontWeight.w700,
                    //     //           )),
                    //     //     ),
                    //     SizedBox(
                    //       height: ScreenUtil().setHeight(12),
                    //     ),
                    //     //     Text("\$208.99",
                    //     //         style: TextStyle(
                    //     //           fontSize: ScreenUtil().setSp(36),
                    //     //         //  fontFamily: "Montserrat",
                    //     //           fontWeight: FontWeight.w700,
                    //     //         ))
                    //     //   ],
                    //     // )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: ScreenUtil().setHeight(14),
                    // ),
                    // SmoothStarRating(
                    //   allowHalfRating: true,
                    //   onRatingChanged: (v) {
                    //     rating = v;
                    //     setState(() {});
                    //   },
                    //   starCount: 5,
                    //   rating: rating,
                    //   size: 22,
                    //   color: Colors.black,
                    //   borderColor: Colors.white,
                    //   spacing: 0.0,
                    // ),
                    SizedBox(
                      height: ScreenUtil().setHeight(20),
                    ),
                    // Text(
                    //   "Size",
                    //   style: TextStyle(
                    //     fontSize: ScreenUtil().setSp(36),
                    //     //fontFamily: "Montserrat",
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    FirebaseGridSelector(product: widget.product),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     ConstrainedBox(
                    //       constraints: BoxConstraints(
                    //         maxWidth: ScreenUtil().setWidth(460),
                    //       ),
                    //       child: Text(
                    //         desc,
                    //         style: TextStyle(
                    //           fontSize: ScreenUtil().setSp(35),
                    //           //   fontFamily: "Montserrat",
                    //         ),
                    //       ),
                    //     ),
                    //     CircularButton(
                    //       color: Colors.black,
                    //       icon: Icon(Icons.shopping_cart, color: Colors.white),
                    //       onPressed: () {},
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // _getVariant(List documents) {

  //   return
  //   documents.map((e) => BaseGridSelectorItem(
  //              key: int.parse(e.data['no'].toString()), label: e.documentID))
  //          .toList();

  //   // Firestore.instance
  //   //     .collection("companies/Al-Hayya/Products/GhoaYeyx88AEECICeuZm/Variant")
  //   //     .orderBy('no')
  //   //     .getDocuments()
  //   //     .then((querySnapshot) {
  //   //   var list = querySnapshot.documents;

  //   //   variant = list
  //   //       .map((e) => BaseGridSelectorItem(
  //   //           key: int.parse(e.data['no'].toString()), label: e.documentID))
  //   //       .toList();

  //   //   setState(() {});
  //   // });
  // }
  // return [
  //   BaseGridSelectorItem(key: 1, label: "XXS"),
  //   BaseGridSelectorItem(key: 2, label: "XS"),
  //   BaseGridSelectorItem(key: 3, label: "S"),
  //   BaseGridSelectorItem(key: 4, label: "M"),
  //   BaseGridSelectorItem(key: 5, label: "L"), //, isEnabled: false),
  //   BaseGridSelectorItem(key: 6, label: "XL"),
  //   BaseGridSelectorItem(key: 7, label: "XXL"),
  //   BaseGridSelectorItem(key: 8, label: "Kid XXS"),
  //   BaseGridSelectorItem(key: 9, label: "Kid XS"),
  //   BaseGridSelectorItem(key: 10, label: "Kid S"),
  //   BaseGridSelectorItem(key: 11, label: "Kid M"),
  //   BaseGridSelectorItem(
  //       key: 12, label: "Kid L"), //, isEnabled: false),
  //   BaseGridSelectorItem(key: 13, label: "Kid XL"),
  //   BaseGridSelectorItem(key: 14, label: "Kid XXL"),
  // ];

}

class FirebaseGridSelector extends StatelessWidget {
  final Product product;

  FirebaseGridSelector({
    this.product,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
 //   VarianProvider varianpfd = Provider.of<VarianProvider>(context);

    return StreamBuilder(
        stream: Firestore.instance
            .collection(
                "companies/Al-Hayya/Products/" + product.idprod + "/Variant")
            .orderBy('no')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Variant> vars = snapshot.data.documents
                .map<Variant>((e) => Variant.fromSnapshot(e))
                .toList();

            return GridSelector<int>(
              title: "SIZE",
              items: _getVariant(snapshot.data.documents),
              onSelectionChanged: (option) {
                Variant varian = vars.firstWhere((vari) => vari.no == option,
                    orElse: () => null);
              //  print(varian.label);
                _showModalBottomSheet(context, product, varian);
              },
            );
          } else
            return Container();
        });
  }

  _getVariant(List documents) {
    return documents
        .map((e) => BaseGridSelectorItem(
            key: int.parse(e.data['no'].toString()), label: e.documentID))
        .toList();
  }
}

void _showModalBottomSheet(
    context, Product product, Variant varian, ) {


  showModalBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      // ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return VarianDetail(product,varian);
      });
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.4;

    canvas.drawLine(
        Offset(0, size.height - 4), Offset(size.width, 4), linePaint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LinePainter oldDelegate) => false;
}
