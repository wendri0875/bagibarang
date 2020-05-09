import 'package:intl/intl.dart';

class Billable {
  var custid;
  var ttlitem;

  Billable({this.custid, this.ttlitem}) {
    this.custid = custid;
    this.ttlitem = ttlitem;
  }

  static Billable fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Billable(
      custid: map["custid"],
      ttlitem: map["ttlitem"],
    );
  }

    

  Map<String, dynamic> toMap() {
    return {
      if (custid != null) 'custid': custid,
      if (ttlitem != null) 'ttlitem': ttlitem,
     
    };
  }
}
