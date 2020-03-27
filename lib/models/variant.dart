import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Variant {
  var no;
  var label;
  var price;
  var weight;

  Variant({this.no, this.label, this.price, this.weight}) {
    this.no = no;
    this.label = label;
    this.price = price;
    this.weight = weight;
  }

  Variant.fromSnapshot(DocumentSnapshot snapshot) {
    var f = new NumberFormat("#,###.#", "en_US");
    //var wf = new NumberFormat("#,###.#", "en_US");

    this.no = snapshot?.data["no"]?.toDouble() ?? null;
    this.label = snapshot.documentID;
    this.price = snapshot?.data["price"]?.toDouble() ?? null;
    this.price = snapshot?.data["price"] == null ? "" : f.format(this.price);
    this.weight = snapshot?.data["weight"]?.toDouble() ?? null;
    this.weight = snapshot?.data["weight"] == null ? "" : f.format(this.weight);
  }
}
