import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userData =
      FirebaseFirestore.instance.collection("UserDetail");

  Future updateUserData(String email, String password) async {
    return await userData.doc(uid).set({
      'email': email,
      'password': password,
    });
  }
}
