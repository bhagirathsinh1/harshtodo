import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConnection {
  var user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;

  Future<void> saveToFirebase(
      String title, String description, String serverTimestamp) async {
    DocumentReference docref = await firestore
        .collection("Users")
        .doc(user!.uid)
        .collection("ToDos")
        .add({
      "title": title,
      "description": description,
      "time": serverTimestamp,
    });
    var refid = docref.id;
    print("document id $refid");
  }

  Future<void> updateToFirebase() async {}
}
