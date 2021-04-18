class MyUser {
  String uid;
  String email;
  String password;
  String phone;
  String name;
  String photoUrl;

  MyUser(
      {this.uid,
      this.email,
      this.password,
      this.phone,
      this.name,
      this.photoUrl});

  MyUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    name = json['name'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
