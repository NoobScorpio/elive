class Promo {
  List<PromoRecords> records;

  Promo({this.records});

  Promo.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<PromoRecords>();
      json['records'].forEach((v) {
        records.add(new PromoRecords.fromJson(v));
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

class PromoRecords {
  String promoId;
  String name;
  String discount;
  String expiryDate;

  PromoRecords({this.promoId, this.name, this.discount, this.expiryDate});

  PromoRecords.fromJson(Map<String, dynamic> json) {
    promoId = json['promoId'];
    name = json['name'];
    discount = json['discount'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promoId'] = this.promoId;
    data['name'] = this.name;
    data['discount'] = this.discount;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}
