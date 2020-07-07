import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Alloc {
  var allocid;
  var orderid;
  var custid;
  var idprod;
  var varian;
  var date;
  var qty;
  var idcompany;
  var unshipped;

  Alloc(
      {this.allocid,
      this.orderid,
      this.custid,
      this.idprod,
      this.varian,
      this.date,
      this.qty,
      this.idcompany,
      this.unshipped}) {
    this.allocid = allocid;
    this.orderid = orderid;
    this.custid = custid;
    this.idprod = idprod;
    this.varian = varian;
    this.date = date;
    this.qty = qty;
    this.idcompany = idcompany;
    this.unshipped = unshipped;
  }

  static Alloc fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    //  timeago.setLocaleMessages('id', timeago.IdMessages());

    //  DateTime o = map["date"].toDate() ?? null;
    //   final d = new DateFormat('dd MMM  hh:mm');
    //var q = map["qty"] ?? null;

    return Alloc(
      allocid: documentId,
      custid: map["custid"],
      orderid: map["orderid"],
      //date: o == null ? "" : timeago.format(o, locale: "id"),
      //  date: o == null ? "" : d.format(o),
      idprod: map["idprod"],
      varian: map["varian"],
      date: map["date"],
      qty: double.parse((map["qty"] ?? 0).toString()),
      idcompany: map["idcompany"],
      unshipped: double.parse((map["unshipped"] ?? 0).toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (orderid != null) 'orderid': orderid,
      if (custid != null) 'custid': custid,
      if (idprod != null) 'idprod': idprod,
      if (varian != null) 'varian': varian,
      if (date != null) 'date': date,
      if (qty != null) 'qty': qty,
      if (idcompany != null) 'idcompany': idcompany,
      if (unshipped != null) 'unshipped': unshipped,
    };
  }
}
