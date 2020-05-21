import 'package:bagi_barang/models/order.dart';
import 'package:intl/intl.dart';

class Invoice {
  var invoiceid;
  var date;
  var custid;
  var custname;
  var recipient;
  var address;
  var telp;
  var ttlweight;
  var subtotal;
  var adjustment;
  var ongkir;
  var total;

  Invoice(
      {this.invoiceid,
      this.date,
      this.custid,
      this.custname,
      this.recipient,
      this.address,
      this.telp,
      this.ttlweight,
      this.subtotal,
      this.adjustment,
      this.ongkir,
      this.total}) {
    this.invoiceid = invoiceid;
    this.custid = custid;
    this.custname = custname;
    this.recipient = recipient;
    this.address = address;
    this.telp = telp;
    this.ttlweight = ttlweight;
    this.subtotal = subtotal;
    this.adjustment = adjustment;
    this.ongkir = ongkir;
    this.total = total;
  }

  static Invoice fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    var f = new NumberFormat("#,###.#");
    final d = new DateFormat('dd MMM  hh:mm');

    DateTime o = map["orderdate"].toDate() ?? null;
    var a = map["allocated"] ?? null;

    return Invoice(
        invoiceid: documentId,
        date: map["date"],
        custid: map["custid"],
        custname: map["custname"],
        recipient: map["recipient"],
        address: map["address"],
        telp: map["telp"],
        ttlweight: double.parse((map["ttlweight"] ?? 0).toString()),
        subtotal: double.parse((map["subtotal"] ?? 0).toString()),
        adjustment: double.parse((map["adjustment"] ?? 0).toString()),
        ongkir: double.parse((map["ongkir"] ?? 0).toString()),
        total: double.parse((map["total"] ?? 0).toString()));
  }

  static Invoice fromOrder(Order order) {
    return Invoice(custid: order.custid);
  }

  Map<String, dynamic> toMap() {
    return {
      if (invoiceid != null) 'invoiceid': invoiceid,
      if (date != null) 'date': date,
      if (custid != null) 'custid': custid,
      if (custname != null) 'custname': custname,
      if (recipient != null) 'recipient': recipient,
      if (address != null) 'address': address,
      if (telp != null) 'telp': telp,
      if (ttlweight != null) 'weight': ttlweight,
      if (subtotal != null) 'subtotal': subtotal,
      if (adjustment != null) 'adjustment': adjustment,
      if (ongkir != null) 'ongkir': ongkir,
      if (total != null) 'total': total,
    };
  }
}
