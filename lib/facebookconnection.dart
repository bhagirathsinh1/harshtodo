import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todo_with_firebase/pages/homePage.dart';

class FacebookConnection {
  final fstorage = FlutterSecureStorage();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> facebookLogin(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;

      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);

      UserCredential credd =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("fbuser uid : ${credd.user!.uid}");
      fstorage.write(key: 'fbid', value: "${credd.user!.uid}");

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    }
    if (result.status == LoginStatus.failed) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${result.status}")),
      );
    }
  }
}
