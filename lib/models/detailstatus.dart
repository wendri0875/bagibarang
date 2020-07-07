class DetailStatus {
  var status;
  var statusname;
  var date;
  var note;

  DetailStatus({
    this.status,
    this.statusname,
    this.date,
    this.note,
  }) {
    this.status = status;
    this.statusname = statusname;
    this.date = date;
    this.note = note;
  }

  static DetailStatus fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return DetailStatus(
        status: int.tryParse(documentId), date: map["date"], note: map["note"]);
  }

  Map<String, dynamic> toMap() {
    return {
      if (date != null) 'date': date,
      if (note != null) 'note': note,
    };
  }
}
