class Booking {
  String userEmail;
  String description;
  String time;
  String firestoreId;
  String date;
  String service;
  int total;
  String status;
  String token;

  Booking(
      {this.userEmail,
      this.token,
      this.status,
      this.description,
      this.time,
      this.firestoreId,
      this.date,
      this.service,
      this.total});

  Booking.fromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'];
    description = json['description'];
    time = json['time'];
    firestoreId = json['firestoreId'];
    date = json['date'];
    service = json['service'];
    total = json['total'];
    token = json['token'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userEmail'] = this.userEmail;
    data['description'] = this.description;
    data['time'] = this.time;
    data['firestoreId'] = this.firestoreId;
    data['date'] = this.date;
    data['service'] = this.service;
    data['total'] = this.total;
    data['token'] = this.token;
    data['status'] = this.status;
    return data;
  }
}
