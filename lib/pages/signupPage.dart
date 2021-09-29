import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  bool showHide1 = true;
  bool showHide2 = true;
  bool progressbar = false;
  final _registerformkey = GlobalKey<FormState>();
  final _remailController = TextEditingController();
  final _rpasswordController = TextEditingController();
  final _rcpasswordController = TextEditingController();

  String registerfullname = "";
  String registeremail = "";
  String registerpassword = "";
  String registercpassword = "";

  // register() {
  //   registerfullname = _rfullnameController.text;
  //   registeremail = _remailController.text;
  //   registerpassword = _rpasswordController.text;
  //   registercpassword = _rcpasswordController.text;
  //   print(
  //       'registered with: $registerfullname + $registeremail + $registerpassword + $registercpassword');
  // }

  FirebaseAuth firebaseauth1 = FirebaseAuth.instance;
  void registerUser() async {}

  togglepsd1() {
    setState(() {
      showHide1 = !showHide1;
    });
  }

  togglepsd2() {
    setState(() {
      showHide2 = !showHide2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                // padding: EdgeInsets.only(
                //     top: MediaQuery.of(context).size.height * 0),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height / 3.5,
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Icon(
                          Icons.person_outline,
                          size: 90,
                          color: Color(0xFF00abff),
                          // Colors.black87.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, top: 30),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Color(0xFF00abff),
                              //Colors.black87.withOpacity(0.4),
                              fontSize: 30,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _registerformkey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.3),
                            blurRadius: 14,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: _remailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontWeight: FontWeight.w300),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xFF00abff),
                              ),
                              // hintText: 'Email',
                              labelText: "Email",
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: _rpasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: showHide1,
                            style: TextStyle(fontWeight: FontWeight.w300),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xFF00abff),
                              ),
                              suffixIcon: IconButton(
                                icon: showHide1
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                color: Colors.grey.withOpacity(0.7),
                                onPressed: () {
                                  togglepsd1();
                                },
                              ),
                              //hintText: 'Password',
                              labelText: "Password",
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          margin: EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: _rcpasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(fontWeight: FontWeight.w300),
                            obscureText: showHide2,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Re-enter Password';
                              }
                              if (value != _rpasswordController.text) {
                                return 'Password doesn\'t matched';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xFF00abff),
                                // Colors.black87.withOpacity(0.4),
                              ),
                              suffixIcon: IconButton(
                                icon: showHide2
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                color: Colors.grey.withOpacity(0.7),
                                onPressed: () {
                                  togglepsd2();
                                },
                              ),
                              // hintText: 'Confirm Password',
                              labelText: "Confirm Password",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              progressbar = true;
                            });
                            _registerformkey.currentState!.validate();
                            if (_registerformkey.currentState!.validate()) {
                              try {
                                // ignore: unused_local_variable
                                UserCredential ruserCredential =
                                    await firebaseauth1
                                        .createUserWithEmailAndPassword(
                                            email: _remailController.text,
                                            password:
                                                _rpasswordController.text);
                                // print("user UID = " + ruserCredential.user!.uid);

                                setState(() {
                                  progressbar = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Succesfully Registered"),
                                  duration: Duration(milliseconds: 1500),
                                ));
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => LoginPage()),
                                    (route) => false);
                              } catch (e) {
                                final snackbar =
                                    SnackBar(content: Text(e.toString()));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                                setState(() {
                                  progressbar = false;
                                });
                              }
                            } else {
                              setState(() {
                                progressbar = false;
                              });
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff6bceff),
                                    Color(0xFF00abff),
                                  ],
                                ),
                                // border: Border.all(
                                //     color: Colors.black87.withOpacity(0)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: progressbar
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Register'.toUpperCase(),
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
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 25),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Already have an account ?",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        " Sign In",
                        style: TextStyle(
                            color: Color(0xFF00abff),
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  onTap: () {
                    print("Clicked Don't have an account");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => LoginPage()),
                        (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
