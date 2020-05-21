import 'package:bagi_barang/models/order.dart';
import 'package:intl/intl.dart';

class InvoiceDetail {
  var invoiceid;
  var orderid;
  var idprod;
  var varian;
  var qty;
  var pname;
  var imageUrl;
  var weight;
  var price;
  var discount;
  var linettl;
  var lineweight;

  InvoiceDetail(
      {this.invoiceid,
      this.orderid,
      this.idprod,
      this.varian,
      this.qty,
      this.pname,
      this.imageUrl,
      this.weight,
      this.price,
      this.discount,
      this.linettl,
      this.lineweight}) {
    this.invoiceid = invoiceid;
    this.orderid = orderid;
    this.idprod = idprod;
    this.varian = varian;
    this.qty = qty;
    this.pname = pname;
    this.imageUrl = imageUrl;
    this.weight = weight;
    this.price = price;
    this.discount = discount;
    this.linettl = linettl;
    this.lineweight = lineweight;
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

  static InvoiceDetail fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    var f = new NumberFormat("#,###.#");
    //timeago.setLocaleMessages('id', timeago.IdMessages());
    final d = new DateFormat('dd MMM  hh:mm');

    DateTime o = map["orderdate"].toDate() ?? null;
    // var q = map["orderqty"] ?? null;
    var a = map["allocated"] ?? null;

    return InvoiceDetail(
        invoiceid: documentId,
        orderid: map["orderid"],
        idprod: map["idprod"],
        varian: map["varian"],
        qty: map["qty"],
        pname: map["pname"],
        imageUrl: map["imageUrl"],
        weight: map["weight"],
        price: map["price"],
        discount: map["discount"],
        linettl: map["linettl"],
        lineweight:  map["lineweight"]);
  }

  static InvoiceDetail fromOrder(Order order) {
    return InvoiceDetail(
      orderid: order.orderid,  idprod: order.idprod, varian: order.varian, qty: order.unshipped);
  }

  Map<String, dynamic> toMap() {
    return {
      if (orderid != null) 'orderid': orderid,
      if (idprod != null) 'custid': idprod,
      if (varian != null) 'varian': varian,
      if (qty != null) 'qty': qty,
      if (pname != null) 'pname': pname,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (weight != null) 'weight': weight,
      if (price != null) 'price': price,
      if (discount != null) 'discount': discount,
      if (linettl != null) 'linettl': linettl,
      if (lineweight != null) 'lineweight': lineweight
    };
  }
}
