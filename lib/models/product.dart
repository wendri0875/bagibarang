

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String idprod;
  String image;
  String pdesc;
  String pname;
  double pricestd;
  Timestamp uploaddate;
  double weightstd;

  Product(
      { this.idprod,
        this.image,
      this.pdesc,
      this.pname,
      this.pricestd,
      this.uploaddate,
      this.weightstd}) {
    this.image = image;
    this.pdesc = pdesc;
    this.pname = pname;
    this.pricestd = pricestd;
    this.uploaddate = uploaddate;
    this.weightstd = weightstd;
  }

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    this.idprod = snapshot.documentID;
    this.image = snapshot?.data["image"]?.toString() ?? null;
    this.pdesc = snapshot?.data["pdesc"]?.toString() ?? null;
    this.pname = snapshot?.data["pname"]?.toString() ?? null;
    this.pricestd = snapshot?.data["pricestd"]?.toDouble() ?? null;
    this.uploaddate = snapshot?.data["uploaddate"] ?? null;
    this.weightstd = snapshot?.data["weightstd"]?.toDouble() ?? null;
  }
}
