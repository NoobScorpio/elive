class SliderImages {
  List<SliderRecords> records;

  SliderImages({this.records});

  SliderImages.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = new List<SliderRecords>();
      json['records'].forEach((v) {
        records.add(new SliderRecords.fromJson(v));
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

class SliderRecords {
  String image;

  SliderRecords({this.image});

  SliderRecords.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
