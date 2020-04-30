import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Variant {
  int no;
  String label;
  double price;
  double weight;

  Variant({this.no, this.label, this.price, this.weight}) {
    this.no = no;
    this.label = label;
    this.price = price;
    this.weight = weight;
  }

  Variant.fromSnapshot(DocumentSnapshot snapshot) {
    var f = new NumberFormat("#,###.#", "en_US");
    //var wf = new NumberFormat("#,###.#", "en_US");

    this.no = snapshot?.data["no"]?? null;
    this.label = snapshot.documentID;
    this.price = snapshot?.data["price"]?.toDouble() ?? null;
    //this.price = snapshot?.data["price"] ;== null ? "" : f.format(this.price);
    this.weight = snapshot?.data["weight"]?.toDouble() ?? null;
    //this.weight = snapshot?.data["weight"] == null ? "" : f.format(this.weight);
  }


  static Variant fromMap(Map<String, dynamic> map, String documentId) {
    //var f = new NumberFormat("#,###.#", "en_US");

    if (map == null) return null;

    return Variant(
    no:map["no"],
    label : documentId,
    // price : map["price"] == null ? "":f.format(map["price"]),
    // weight : map["weight"] == null ? "":f.format(map["weight"])
    
     price : map["price"]?.toDouble() ?? null,
     weight : map["weight"]?.toDouble() ?? null
    );
  }


  Map<String, dynamic> toMap() {
    return {
      if (no != null) 'no': no,
      if (label != null) 'label': label,
      if (price != null) 'price': price,
      if (weight != null) 'weight': weight,
    };
  }
}
