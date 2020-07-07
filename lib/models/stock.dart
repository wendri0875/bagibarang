import 'package:intl/intl.dart';

class Stock {
  var stockid;
  var qty;
  var stockdate;
  var note;

  Stock({this.stockid, this.qty, this.stockdate, this.note}) {
    this.stockid = stockid;
    this.qty = qty;
    this.stockdate = stockdate;
    this.note = note;
  }

  static Stock fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    // var f = new NumberFormat("#,###.#");
    //timeago.setLocaleMessages('id', timeago.IdMessages());

    final d = new DateFormat('dd MMM  hh:mm');

    DateTime o = map["stockdate"].toDate() ?? null;
    //  var q = map["qty"] ?? null;

    return Stock(
        stockid: documentId,
        note: map["note"],
        stockdate: o == null ? "" : d.format(o),
        //  qty: q == null ? "" : f.format(q));
        qty: map["qty"]);
  }

  Map<String, dynamic> toMap() {
    return {
      if (note != null) 'note': note,
      if (stockdate != null) 'stockdate': stockdate,
      if (qty != null) 'qty': qty,
    };
  }
}
