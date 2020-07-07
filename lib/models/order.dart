import 'package:intl/intl.dart';

class Order {
  var orderid;
  var custid;
  var idprod;
  var imageUrl;
  var varian;
  var orderdate;
  var orderqty;
  var allocated;
  var idcompany;
  var pending;
  var pendingqty;
  var pname;
  var weight;
  var price;

  Order({
    this.orderid,
    this.custid,
    this.idprod,
    this.imageUrl,
    this.varian,
    this.orderdate,
    this.orderqty,
    this.allocated,
    this.idcompany,
    this.pending,
    this.pendingqty,
    this.pname,
    this.weight,
    this.price,
  }) {
    this.orderid = orderid;
    this.custid = custid;
    this.idprod = idprod;
    this.imageUrl = imageUrl;
    this.varian = varian;
    this.orderdate = orderdate;
    this.orderqty = orderqty;
    this.allocated = allocated;
    this.idcompany = idcompany;
    this.pending = pending;
    this.pendingqty = pendingqty;
    this.pname = pname;
    this.weight = weight;
    this.price = price;
  }

  // Order.fromSnapshot(DocumentSnapshot snapshot) {
  //   var f = new NumberFormat("#,###.#", "id");
  //   //var wf = new NumberFormat("#,###.#", "en_US");

  //   timeago.setLocaleMessages('id', timeago.IdMessages());

  //   this.custid = snapshot?.data["custid"] ?? null;
  //   this.orderid = snapshot.documentID;
  //   //this.orderdate = snapshot?.data["orderdate"] ?? null;

  //   DateTime o = snapshot.data["orderdate"].toDate() ?? null;
  //   this.orderdate = o == null ? "" : timeago.format(o, locale: "id");

  //   var q = snapshot?.data["orderqty"] ?? null;
  //   this.orderqty = q == null ? "" : f.format(q);
  // }

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
        idprod: map["idprod"],
        varian: map["varian"],
        orderdate: map["orderdate"],
        //  orderdate: o == null ? "" : d.format(o),
        //orderqty: q == null ? "" : f.format(q),
        orderqty: double.parse((map["orderqty"] ?? 0).toString()),
        allocated: double.parse((map["allocated"] ?? 0).toString()),
        idcompany: map["idcompany"],
        pending: map["pending"],
        pendingqty: double.parse((map["pendingqty"] ?? 0).toString()));
  }

  Map<String, dynamic> toMap() {
    return {
      if (custid != null) 'custid': custid,
      if (idprod != null) 'idprod': idprod,
      if (varian != null) 'varian': varian,
      if (orderdate != null) 'orderdate': orderdate,
      if (orderqty != null) 'orderqty': orderqty,
      if (allocated != null) 'allocated': allocated,
      if (idcompany != null) 'idcompany': idcompany,
      if (pending != null) 'pending': pending,
      if (pendingqty != null) 'pending': pendingqty,
    };
  }
}
