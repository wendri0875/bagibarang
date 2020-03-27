import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Order {
  var orderid;
  var custid;
  var orderdate;
  var orderqty;

  Order({this.orderid, this.custid, this.orderdate, this.orderqty}) {
    this.orderid = orderid;
    this.custid = custid;
    this.orderdate = orderdate;
    this.orderqty = orderqty;
  }

  Order.fromSnapshot(DocumentSnapshot snapshot) {
    var f = new NumberFormat("#,###.#", "id");
    //var wf = new NumberFormat("#,###.#", "en_US");

     timeago.setLocaleMessages('id', timeago.IdMessages());

    this.custid = snapshot?.data["custid"] ?? null;
    this.orderid = snapshot.documentID;
    //this.orderdate = snapshot?.data["orderdate"] ?? null;

    DateTime o = snapshot.data["orderdate"].toDate() ?? null;
    this.orderdate = o == null ? "" : timeago.format(o, locale: "id");

    var q = snapshot?.data["orderqty"] ?? null;
    this.orderqty = q == null ? "" : f.format(q);
  }
}
