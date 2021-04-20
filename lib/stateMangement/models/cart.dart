class CartItem {
  int id;
  int pid;
  String pName;
  String name;
  String price;
  int qty;

  CartItem({this.qty, this.id, this.pName, this.pid, this.price, this.name});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    pName = json['pName'];
    price = json['price'];
    name = json['name'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pid'] = this.pid;
    data['id'] = this.id;
    data['pName'] = this.pName;
    data['price'] = this.price;
    data['name'] = this.name;
    data['qty'] = this.qty;
    return data;
  }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is CartItem &&
  //         runtimeType == other.runtimeType &&
  //         id == other.id &&
  //         pid == other.pid &&
  //         pName == other.pName &&
  //         price == other.price;

  // @override
  // int get hashCode =>
  //     id.hashCode + name.hashCode + pName.hashCode + pid.hashCode;
  //
  // @override
  // List<Object> get props => throw UnimplementedError();
}

class MyCart {
  MyCart._privateConstructor();
  static final _instance = MyCart._privateConstructor();
  factory MyCart() {
    return _instance;
  }
  List<CartItem> cartItem;

  // Cart({this.cartItem});

  MyCart.fromJson(Map<String, dynamic> json) {
    if (json['CartItem'] != null) {
      cartItem = new List<CartItem>();
      json['CartItem'].forEach((v) {
        cartItem.add(new CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartItem != null) {
      data['CartItem'] = this.cartItem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
