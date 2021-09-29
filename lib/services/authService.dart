import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_with_firebase/pages/homePage.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future signInAnon(BuildContext context) async {
    try {
      UserCredential result = await auth.signInAnonymously();
      User? user = result.user;
      storage.write(key: 'annonuid', value: user!.uid.toString());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> googleSignin(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storeTokenandData(userCredential);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
            duration: Duration(milliseconds: 1500),
          ));
        }
      } else {
        print("google acc is null");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> storeTokenandData(UserCredential ucredential) async {
    await storage.write(
        key: 'token', value: ucredential.credential!.token.toString());
    await storage.write(key: 'UserCredential', value: ucredential.toString());
    // ignore: unused_local_variable
    String? token = await storage.read(key: 'token');
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: 'token');
      await storage.delete(key: 'uid');
      await storage.delete(key: 'verificationID');
      await storage.delete(key: 'annonuid');
      await storage.delete(key: 'fbid');
    } catch (e) {
      print('$e + Error while signing out');
    }
  }

  void showSnackbar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackbar(context, "You're verified.");
    };
    PhoneVerificationFailed verificationFailed = (FirebaseException exception) {
      showSnackbar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingtoken]) {
      showSnackbar(context, "OTP sent.");
      setData(verificationId);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      // showSnackbar(context, "Timeout");
    };

    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      // ignore: unused_local_variable
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    // final AuthCredential credential = PhoneAuthProvider.credential(
    //     verificationId: verificationId, smsCode: smsCode);

    // FirebaseAuth _auth = FirebaseAuth.instance;

    // UserCredential userCredential =
    //     await auth.signInWithCredential(credential).then((value) {
    //   return value;
    // }).catchError((e) {
    //   print(e);
    // });
    // final User user = await _auth.signInWithCredential(credential).then((user) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => DashboardPage(uid: user.user.uid)),
    //   );
    // }).catchError((e) {
    //   print(e);
    // });
  }
}
