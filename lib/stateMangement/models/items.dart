class Items {
  List<ItemRecords> records;

  Items({this.records});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<ItemRecords>();
      json['records'].forEach((v) {
        records.add(new ItemRecords.fromJson(v));
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

class ItemRecords {
  String itemId;
  String itemName;
  String itemPrice;
  String packageId;
  String itemPicture;
  String timeRequire;
  ItemRecords(
      {this.itemId,
      this.itemName,
      this.itemPrice,
      this.timeRequire,
      this.packageId,
      this.itemPicture});

  ItemRecords.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    itemName = json['itemName'];
    itemPrice = json['itemPrice'];
    packageId = json['packageId'];
    itemPicture = json['itemPicture'];
    timeRequire = json['timeRequire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['itemName'] = this.itemName;
    data['itemPrice'] = this.itemPrice;
    data['packageId'] = this.packageId;
    data['itemPicture'] = this.itemPicture;
    data['timeRequire'] = this.timeRequire;
    return data;
  }
}
