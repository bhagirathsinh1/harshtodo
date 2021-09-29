import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';
import 'package:todo_with_firebase/services/authService.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  bool wait = false;
  bool pressed = false;
  String buttonName = "Send";
  late Timer timer;
  int start = 45;
  String finalverificationID = "";
  String smsCode = "";
  TextEditingController otpcontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  AuthClass authclass = AuthClass();
  final phStorage = FlutterSecureStorage();

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            // take stack here for center all data in singlechildscrollview

            children: [
              SingleChildScrollView(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,

                  child: Column(
                    children: [
                      Container(
                        // padding: EdgeInsets.only(
                        //     top: MediaQuery.of(context).size.height * 0.00),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.phone_android,
                                size: 90,
                                color: Color(0xFF00abff),
                                // Colors.black87.withOpacity(0.4),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, top: 10),
                                child: Text(
                                  "OTP Verification",
                                  style: TextStyle(
                                      color: Color(0xFF00abff),
                                      //Colors.black87.withOpacity(0.4),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  //color: Colors.black.withOpacity(0.15),
                                  color: Colors.black87.withOpacity(0.3),
                                  blurRadius: 14,
                                  offset: Offset(5, 5),
                                ),
                              ]),
                          child: Form(
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  child: TextFormField(
                                    controller: phonenumbercontroller,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w300),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      hintText: "Enter your phone Number",
                                      hintStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 19, horizontal: 10),
                                      prefixIcon: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 0),
                                          child: Text(
                                            " +91-",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: wait
                                      ? null
                                      : () async {
                                          _sendOtpToNumber();
                                        },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff6bceff),
                                            Color(0xFF00abff),
                                          ],
                                        ),
                                        border: Border.all(
                                            color: Colors.black87
                                                .withOpacity(0.1)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Center(
                                      child: Text(
                                        buttonName,
                                        style: TextStyle(
                                            color: wait
                                                ? Colors.white.withOpacity(0.5)
                                                : Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.grey,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12),
                                      ),
                                    ),
                                    Text(
                                      "Enter 6 digit OTP",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        color: Colors.grey,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: PinCodeTextField(
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: Colors.transparent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    length: 6,
                                    obscureText: false,
                                    blinkWhenObscuring: true,
                                    animationType: AnimationType.fade,
                                    validator: (v) {
                                      if (v!.length < 6) {
                                      } else {
                                        return null;
                                      }
                                    },
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 45,
                                      fieldWidth: 45,
                                      borderWidth: 1,
                                      //
                                      activeColor:
                                          Colors.black.withOpacity(0.5),
                                      activeFillColor: Colors.white70,
                                      //
                                      inactiveColor:
                                          Colors.black.withOpacity(0.5),
                                      inactiveFillColor: Colors.transparent,
                                      //
                                      selectedFillColor: Colors.transparent,
                                      errorBorderColor: Colors.black87,
                                    ),
                                    cursorColor: Colors.black,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    //errorAnimationController: errorController,
                                    controller: otpcontroller,
                                    keyboardType: TextInputType.number,
                                    // boxShadows: [
                                    //   BoxShadow(
                                    //     offset: Offset(0, 1),
                                    //     color: Colors.black12,
                                    //     blurRadius: 10,
                                    //   )
                                    // ],
                                    onCompleted: (v) {
                                      print("Completed+${otpcontroller.text}");
                                    },
                                    onChanged: (value) {
                                      print(value);
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5,
                                // ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Send OTP again in ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: wait
                                                ? Colors.black87
                                                : Colors.transparent,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      TextSpan(
                                        text: "00:$start",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: wait
                                                ? Colors.black87
                                                : Colors.transparent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: " sec.",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: wait
                                                ? Colors.black87
                                                : Colors.transparent,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    try {
                                      await authclass.signInWithPhoneNumber(
                                          finalverificationID,
                                          otpcontroller.text.trim(),
                                          context);
                                      phStorage.write(
                                          key: 'verificationID',
                                          value: finalverificationID);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.03),
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width / 1.9,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff6bceff),
                                            Color(0xFF00abff),
                                          ],
                                        ),
                                        border: Border.all(
                                            color: Colors.black87
                                                .withOpacity(0.1)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Center(
                                      child: Text(
                                        "Let\'s go!!!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => LoginPage()),
                              (route) => false);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Back to ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 13),
                            ),
                            Text(
                              "Sign in ",
                              style: TextStyle(
                                  color: Color(0xFF00abff),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15),
                            ),
                            Text(
                              "page ?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showsnackbar(String text) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text("$text")));
  // }

  // void startTimer() {
  //   const onsec = Duration(seconds: 1);
  //   // ignore: unused_local_variable
  // Timer _timer = Timer.periodic(onsec, (timer) {
  //   if (start == 0) {
  //     setState(() {
  //       timer.cancel();
  //       wait = false;
  //     });
  //   } else {
  //     setState(() {
  //       start--;
  //     });
  //   }
  // });
  // }

  _sendOtpToNumber() async {
    if (pressed == false) {
      //  startTimer();
      setState(() {
        //start = 30;
        pressed = true;
        wait = true;
        buttonName = "Resend";
      });
      await authclass.verifyPhoneNumber(
          "+91${phonenumbercontroller.text}", context, setData);
      timer = new Timer(const Duration(seconds: 45), () {
        setState(() {
          wait = false;
          pressed = false;
          //buttonName = "Resend";
        });
      });
      // ignore: unused_local_variable
      Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            wait = false;
            start = 45;
          });
        } else {
          if (!mounted) {
            setState(() {
              start--;
            });
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Wait")));
    }
    if (pressed == false) {
      //  startTimer();
      setState(() {
        //start = 30;
        pressed = true;
        wait = true;
        buttonName = "Resend";
      });
      await authclass.verifyPhoneNumber(
          "+91${phonenumbercontroller.text}", context, setData);
      timer = new Timer(const Duration(seconds: 45), () {
        setState(() {
          wait = false;
          pressed = false;
          //buttonName = "Resend";
        });
      });
      // ignore: unused_local_variable
      Timer _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
            wait = false;
            start = 45;
          });
        } else {
          setState(() {
            start--;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sending OTP...")));
    }
  }

  void setData(verificationId) {
    setState(() {
      finalverificationID = verificationId;
    });
    // startTimer();
  }
}
