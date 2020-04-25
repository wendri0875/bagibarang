

import 'package:bagi_barang/ui/widgets/productgrid.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

//import 'horizontallist.dart';

class Products extends StatefulWidget {
  Products({Key key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Widget imageCarousel = Container(
    height: 175.0,
    padding: EdgeInsets.all(10),
    child: Carousel(
      overlayShadow: false,
      borderRadius: true,
      boxFit: BoxFit.cover,
      autoplay: true,
      dotSize: 5.0,
      indicatorBgPadding: 9.0,
      images: [
        new AssetImage('assets/slider/slider1.jpg'),
        new AssetImage('assets/slider/slider2.jpg'),
        new AssetImage('assets/slider/slider3.jpg'),
        new AssetImage('assets/slider/slider4.jpg'),
        new AssetImage('assets/slider/slider5.jpg'),
        new AssetImage('assets/slider/slider6.jpg'),
      ],
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(microseconds: 1500),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 5.0,
        ),
        imageCarousel,
        // Padding(
        //   padding: const EdgeInsets.only(
        //     top: 8.0,
        //     left: 8.0,
        //   ),
        //   child: Text(
        //     'Popular Categories',
        //     style: TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 18.0,
        //         color: Colors.purpleAccent),
        //   ),
        // ),
        //   HorizontalList(),
        //   Padding(
        //     padding: const EdgeInsets.only(
        //       top: 8.0,
        //       left: 8.0,
        //     ),
        //     child: Text(
        //       'Popular Products',
        //       style: TextStyle(
        //           fontWeight: FontWeight.bold,
        //           fontSize: 18.0,
        //           color: Colors.purpleAccent),
        //     ),
        //   ),
        Container(
          height: 400.0,
          child: ProductGrid(),
        )
      ],
    );
  }
}
