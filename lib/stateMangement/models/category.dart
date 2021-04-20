class Category {
  List<Records> records;

  Category({this.records});

  Category.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<Records>();
      json['records'].forEach((v) {
        records.add(new Records.fromJson(v));
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

class Records {
  String packageId;
  String pname;
  String packagePic;

  Records({this.packageId, this.pname, this.packagePic});

  Records.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId'];
    pname = json['pname'];
    packagePic = json['packagePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageId'] = this.packageId;
    data['pname'] = this.pname;
    data['packagePic'] = this.packagePic;
    return data;
  }
}
