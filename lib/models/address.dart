

class Address {
  var recipient;
  var address;
  var phone;


  Address({
    this.recipient,
    this.address,
    var phone,
  }) {
    this.recipient = recipient;
    this.address = address;
    this.phone = phone;
  }

  static Address fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Address(
        recipient: map["recipient"], address: map["address"], phone: map["phone"]);
  }

  Map<String, dynamic> toMap() {
    return {
      if (recipient != null) 'recipient': recipient,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone
    };
  }
}
