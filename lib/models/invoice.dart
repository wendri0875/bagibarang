import 'package:bagi_barang/models/order.dart';

class Invoice {
  var invoiceid;
  var date;
  var custid;
  var custname;
  var addressid;
  var recipient;
  var address;
  var phone;
  var deflt;
  var ttlitem;
  var ttlweight;
  var subtotal;
  var correction;
  var postage;
  var total;
  var status;
  var courier;
  var waybill;
  var paymtd;

  Invoice(
      {this.invoiceid,
      this.date,
      this.custid,
      this.custname,
      this.addressid,
      this.recipient,
      this.address,
      this.phone,
      this.deflt,
      this.ttlitem,
      this.ttlweight,
      this.subtotal,
      this.correction,
      this.postage,
      this.total,
      this.status,
      this.courier,
      this.waybill,
      this.paymtd,
      }) {
    this.invoiceid = invoiceid;
    this.custid = custid;
    this.custname = custname;
    this.addressid = addressid;
    this.recipient = recipient;
    this.address = address;
    this.phone = phone;
    this.deflt = deflt;
    this.ttlitem = ttlitem;
    this.ttlweight = ttlweight;
    this.subtotal = subtotal;
    this.correction = correction;
    this.postage = postage;
    this.total = total;
    this.status = status;
    this.courier = courier;
    this.waybill = waybill;
    this.paymtd =paymtd;
  }

  static Invoice fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Invoice(
        invoiceid: documentId,
        date: map["date"],
        custid: map["custid"],
        custname: map["custname"],
        recipient: map["recipient"],
        addressid: map["addressid"],
        address: map["address"],
        phone: map["phone"],
        deflt: map["deflt"],
        status: map["status"],
        courier: map["courier"],
        waybill: map["waybill"],
        paymtd: map["paymtd"],
        ttlitem: double.parse((map["ttlitem"] ?? 0).toString()),
        ttlweight: double.parse((map["ttlweight"] ?? 0).toString()),
        subtotal: double.parse((map["subtotal"] ?? 0).toString()),
        correction: double.parse((map["correction"] ?? 0).toString()),
        postage: double.parse((map["postage"] ?? 0).toString()),
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
      if (addressid != null) 'addressid': addressid,
      if (recipient != null) 'recipient': recipient,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (deflt != null) 'deflt': deflt,
      if (status != null) 'status': status,
      if (ttlitem != null) 'ttlitem': ttlitem,
      if (ttlweight != null) 'ttlweight': ttlweight,
      if (subtotal != null) 'subtotal': subtotal,
      if (correction != null) 'correction': correction,
      if (postage != null) 'postage': postage,
      if (total != null) 'total': total,
      if (courier != null) 'courier': courier,
      if (waybill != null) 'waybill': waybill,
      if (paymtd != null) 'paymtd': paymtd,
    };
  }
}
