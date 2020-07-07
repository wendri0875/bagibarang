class Address {
  var addressid;
  var recipient;
  var address;
  var phone;
  var deflt;

  Address({
    this.addressid,
    this.recipient,
    this.address,
    this.phone,
    this.deflt,
  }) {
    this.addressid = addressid;
    this.recipient = recipient;
    this.address = address;
    this.phone = phone;
    this.deflt = deflt;
  }

  static Address fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Address(
      addressid: documentId,
        recipient: map["recipient"],
        address: map["address"],
        phone: map["phone"],
        deflt: map["deflt"]);
  }

  Map<String, dynamic> toMap() {
    return {
      if (recipient != null) 'recipient': recipient,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (deflt != null) 'deflt': deflt,
    };
  }
}
