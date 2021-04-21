class BookingList {
  List<BookingListRecords> records;

  BookingList({this.records});

  BookingList.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<BookingListRecords>();
      json['records'].forEach((v) {
        records.add(new BookingListRecords.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.records != null) {
      data['records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingListRecords {
  String id;
  String firestoreId;
  String userEmail;
  String time;
  String total;
  String date;
  String service;

  BookingListRecords(
      {this.id,
      this.firestoreId,
      this.userEmail,
      this.time,
      this.total,
      this.date,
      this.service});

  BookingListRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firestoreId = json['firestoreId'];
    userEmail = json['userEmail'];
    time = json['time'];
    total = json['total'];
    date = json['date'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firestoreId'] = this.firestoreId;
    data['userEmail'] = this.userEmail;
    data['time'] = this.time;
    data['total'] = this.total;
    data['date'] = this.date;
    data['service'] = this.service;
    return data;
  }
}
