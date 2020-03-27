import 'dart:typed_data';

import 'package:bagi_barang/controls/DataHolder.dart';
import 'package:bagi_barang/models/product.dart';
import 'package:bagi_barang/pages/productDetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatefulWidget {
  ProductGrid({Key key}) : super(key: key);

  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  var productList = [
    {"name": "Camera", "image": "assets/products/camera1.jpg", "price": "100"},
    {
      "name": "Home Appliances",
      "image": "assets/products/homeappliance1.jpg",
      "price": "500"
    },
    {"name": "Sun Glass", "image": "assets/products/glass1.jpg", "price": "80"},
    {
      "name": "Men's Fashion",
      "image": "assets/products/man1.jpg",
      "price": "100"
    },
    {
      "name": "Jewellery",
      "image": "assets/products/jewellery1.jpg",
      "price": "160"
    },
    {"name": "Mobile", "image": "assets/products/mobile1.jpg", "price": "400"},
    {"name": "Shoe", "image": "assets/products/shoe1.jpg", "price": "280"}
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('companies/Al-Hayya/Products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');

          if (!snapshot.hasData)
            return const Text('Loading...');
          else {
            if (snapshot.connectionState == ConnectionState.active ) {
              return GridView.builder(
                itemCount: snapshot.data.documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  Product product = Product.fromSnapshot(snapshot.data.documents[index]);
                  return SingleProduct(product: product
                   // prodName: snapshot.data.documents[index]['name'],
                    // prodPrice: snapshot.data.documents[index]['price'],
                   // prodImage: snapshot.data.documents[index]['image'],
                   // idprod: snapshot.data.documents[index].documentID,
                    // prodName: productList[index]['name'],
                    // prodPrice: productList[index]['price'],
                    // prodImage: productList[index]['image'],
                  );
                },
              );
            }
            return null;
          }
        });
  }
}

class SingleProduct extends StatefulWidget {
 final Product product;
  // final idprod;
  // final prodName;
  // final prodImage;
  // final prodPrice;

  SingleProduct({this.product});
  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  Uint8List imageFile;

  StorageReference imageReference =
      FirebaseStorage.instance.ref().child("prodimg");

  getimage() {
    int maxsize = 7 * 1024 * 1024;
    imageReference
        .child(widget.product.image)
        .getData(maxsize)
        .then((data) => {
              this.setState(() {
                imageFile = data;
                imageData.putIfAbsent(widget.product.image, () {
                  return data;
                });
              })
            })
        .catchError((error) {
      debugPrint(error);
    });
  }

  Widget decideGridTileWidget() {
    if (imageFile == null) {
      return Image.asset('assets/placeholder.png');
      // return Center(
      //   child: Text("No Data"),
      // );
    } else {
      return Image.memory(imageFile, fit: BoxFit.cover);
    }
  }

  @override
  void initState() {
    super.initState();
    if (!imageData.containsKey(widget.product.image)) {
      getimage();
    } else {
      this.setState(() {
        imageFile = imageData[widget.product.image];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      child: Card(
        elevation: 6.0,
        color: Colors.cyanAccent,
        child: Hero(
          tag: widget.product.idprod,
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ProductDetail(product:widget.product,imageFile: imageFile )));
              },
              child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: ListTile(
                    leading: Text(
                      widget.product.pname,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // title: Text(
                    //   "\$$prodPrice",
                    //   style: TextStyle(
                    //       color: Colors.green,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16.0),
                    // ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //  child: Image.asset(widget.prodImage, fit: BoxFit.cover),
                  child: decideGridTileWidget(),
                  // child: FadeInImage(
                  //     fit: BoxFit.cover,
                  //     placeholder: AssetImage('assets/placeholder.png'),
                  //     image: CacheImage(
                  //         'gs://bagibarang-f6e64.appspot.com/prodimg/' +
                  //             widget.prodImage))
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
