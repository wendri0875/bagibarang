

import 'address.dart';

class Customer {
  var custid;
  var custname;
  var phone;
  List<Address> addresses;

  Customer({
    this.custid,
    this.custname,
    var phone,
  }) {
    this.custid = custid;
    this.custname = custname;
    this.phone = phone;
  }

  static Customer fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Customer(
        custid: map["custid"], custname: map["custname"], phone: map["phone"]);
  }

  Map<String, dynamic> toMap() {
    return {
      if (custid != null) 'custid': custid,
      if (custname != null) 'custname': custname,
      if (phone != null) 'phone': phone
    };
  }
}
