import 'package:bagi_barang/models/alloc.dart';
import 'package:bagi_barang/models/order.dart';
import 'package:intl/intl.dart';

class InvoiceDetail {
  var invoicedetailid;
  var invoiceid;
  var orderid;
  var allocid;
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
  var cancel;

  InvoiceDetail(
      {this.invoicedetailid,
      this.invoiceid,
      this.orderid,
      this.allocid,
      this.idprod,
      this.varian,
      this.qty,
      this.pname,
      this.imageUrl,
      this.weight,
      this.price,
      this.discount,
      this.linettl,
      this.lineweight,
      this.cancel}) {
    this.invoicedetailid = invoicedetailid;
    this.invoiceid = invoiceid;
    this.orderid = orderid;
    this.allocid = allocid;
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
    this.cancel = cancel;
  }

  static InvoiceDetail fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return InvoiceDetail(
        invoicedetailid: documentId,
        allocid: map["allocid"],
        invoiceid: map["invoiceid"],
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
        lineweight: map["lineweight"],
        cancel: map["cancel"]);
  }

  static InvoiceDetail fromAlloc(Alloc alloc) {
    return InvoiceDetail(
        orderid: alloc.orderid,
        idprod: alloc.idprod,
        varian: alloc.varian,
        qty: alloc.unshipped,
        allocid: alloc.allocid);
  }

  Map<String, dynamic> toMap() {
    return {
      if (invoiceid != null) 'invoiceid': invoiceid,
      if (orderid != null) 'orderid': orderid,
      if (allocid != null) 'allocid': allocid,
      if (idprod != null) 'idprod': idprod,
      if (varian != null) 'varian': varian,
      if (qty != null) 'qty': qty,
      if (pname != null) 'pname': pname,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (weight != null) 'weight': weight,
      if (price != null) 'price': price,
      if (discount != null) 'discount': discount,
      if (linettl != null) 'linettl': linettl,
      if (lineweight != null) 'lineweight': lineweight,
      if (cancel != null) 'cancel': cancel
    };
  }
}
