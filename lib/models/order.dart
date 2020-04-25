import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Order {
  var orderid;
  var custid;
  var orderdate;
  var orderqty;
  var allocated;

  Order(
      {this.orderid,
      this.custid,
      this.orderdate,
      this.orderqty,
      this.allocated}) {
    this.orderid = orderid;
    this.custid = custid;
    this.orderdate = orderdate;
    this.orderqty = orderqty;
    this.allocated = allocated;
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

  static Order fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    var f = new NumberFormat("#,###.#");
    //timeago.setLocaleMessages('id', timeago.IdMessages());
    final d = new DateFormat('dd MMM  hh:mm');

    DateTime o = map["orderdate"].toDate() ?? null;
    // var q = map["orderqty"] ?? null;
    var a = map["allocated"] ?? null;

    return Order(
        orderid: documentId,
        custid: map["custid"],
        orderdate: o == null ? "" : d.format(o),
        //orderqty: q == null ? "" : f.format(q),
        orderqty: map["orderqty"],
        allocated: map["allocated"]??0);
  }

  Map<String, dynamic> toMap() {
    return {
      if (custid != null) 'custid': custid,
      if (orderdate != null) 'orderdate': orderdate,
      if (orderqty != null) 'orderqty': orderqty,
      if (allocated != null) 'allocated': allocated,
    };
  }
}
