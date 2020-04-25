import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Alloc {
  var allocid;
  var orderid;
  var date;
  var qty;

  Alloc({this.allocid, this.date, this.qty}) {
    this.allocid = allocid;
    this.date = date;
    this.qty = qty;
  }

  static Alloc fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    timeago.setLocaleMessages('id', timeago.IdMessages());

    DateTime o = map["date"].toDate() ?? null;
    final d = new DateFormat('dd MMM  hh:mm');
    //var q = map["qty"] ?? null;

    return Alloc(
        allocid: documentId,
        //date: o == null ? "" : timeago.format(o, locale: "id"),
        date: o == null ? "" : d.format(o),
        qty: map["qty"]);
  }

  Map<String, dynamic> toMap() {
    return {
      if (allocid != null) 'allocid': allocid,
      if (date != null) 'date': date,
      if (qty != null) 'qty': qty,
    };
  }
}
