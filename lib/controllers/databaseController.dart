import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elive/stateMangement/models/myUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Database {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> userAvailable(uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    print("USER AVAILABLE : ${snapshot.data()}");
    return snapshot.data() != null;
  }

  Future<MyUser> getUser({User user}) async {
    try {
      var doc = await userCollection.doc(user.uid).get();
      MyUser myUser = MyUser.fromJson(doc.data());
      return myUser;
    } catch (e) {
      print("GET USER EXCEPTION $e");
      return null;
    }
  }

  Future<bool> createUser({MyUser user}) async {
    try {
      await userCollection.doc(user.uid).set(user.toJson());
      print("User Created:${user.uid} ");
      return true;
    } catch (e) {
      print("CREATE USER EXCEPTION $e");
      return false;
    }
  }
}
