import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo_with_firebase/pages/homePage.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';
import 'package:todo_with_firebase/services/authService.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin1();
  }

  checkLogin1() async {
    await checklogin();
  }

  Widget currentpage = LoginPage();
  AuthClass aclass = AuthClass();
  final storage = new FlutterSecureStorage();

  Future<void> checklogin() async {
    String? token = await storage.read(key: 'token');
    String? uid = await storage.read(key: 'uid');
    String? phkey = await storage.read(key: 'verificationID');
    String? annonuid = await storage.read(key: 'annonuid');
    String? fbid = await storage.read(key: 'fbid');

    print('token : $token');
    print('uid of logged in user : $uid');
    print('phkey of logged in user : $phkey');
    print('annonuid is : $annonuid');
    print('fbuser uid is : $fbid');
    if (token != null ||
        uid != null ||
        phkey != null ||
        annonuid != null ||
        fbid != null) {
      setState(() {
        currentpage = HomePage();
      });
    } else {
      print("Token is Null so navigate to login screen");
    }
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => currentpage),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
