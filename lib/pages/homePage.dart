import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';
import 'package:todo_with_firebase/firebaseConnection.dart';
import 'package:todo_with_firebase/pages/loginPage.dart';
import 'package:todo_with_firebase/services/authService.dart';
import 'package:todo_with_firebase/todoCard.dart';

import '../search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authclass = AuthClass();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController titlecontroller = TextEditingController();

  final secstorage = FlutterSecureStorage();
  AuthClass aclass = AuthClass();
  FirebaseConnection fconnection = FirebaseConnection();
  var user = FirebaseAuth.instance.currentUser;
  final _addnotekey = GlobalKey<FormState>();
  String sort = 'time';
  bool boolsort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[200],
        title: Text(
          "To-Do",
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: ListSearch());
            },
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {
              _showbottomsheetforsortdata(context);
            },
            icon: Icon(
              Icons.sort,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {
              authclass.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => LoginPage()),
                  (route) => false);
              print("Clicked Signout");
            },
            icon: Icon(Icons.logout_rounded, color: Colors.black87),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(user?.uid)
              .collection("ToDos")
              .orderBy(sort, descending: boolsort)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> docss = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return TodoCard(
                        title:
                            docss["title"] == "" ? "Untitled" : docss["title"],
                        description: docss["description"] == null
                            ? "Not described"
                            : docss["description"],
                        time: docss["time"] == null ? "00:00" : docss["time"],
                        utitle: docss["title"],
                        udesc: docss["description"],
                        snap: snapshot,
                        indexx: index,
                      );
                    }),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 20, bottom: 20),
                  child: FloatingActionButton(
                    onPressed: () {
                      // snapshot.data!.docs[0].reference.update(({
                      //   "title": "5",
                      //   "description": "updated5",
                      //   "time": "01:01 PM",
                      // }));
                      //snapshot.data!.docs[0].reference.delete();
                      showAddnoteDialog();
                      setState(() {
                        titlecontroller.text = "";
                        descriptioncontroller.text = "";
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void showAddnoteDialog() {
    showCupertinoDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: Text("Add Note")),
        titleTextStyle: TextStyle(
            color: Colors.blue[400],
            fontSize: 25,
            letterSpacing: 1,
            fontWeight: FontWeight.w400),
        content: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _addnotekey,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '         *Enter Title';
                          }
                          return null;
                        },
                        controller: titlecontroller,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 21,
                        ),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            hintText: 'Title'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '         *Enter Description';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        controller: descriptioncontroller,
                        cursorColor: Colors.black87,
                        autocorrect: true,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 17),
                        maxLines: 5,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 10),
                            border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            // enabledBorder: OutlineInputBorder(),
                            // focusedBorder: OutlineInputBorder(),
                            hintText: "Description"),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border:
                          Border.all(color: Colors.black87.withOpacity(0.4)),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        _addnotekey.currentState!.validate();
                        if (_addnotekey.currentState!.validate()) {
                          DateTime times = DateTime.now();
                          final DateFormat formatter =
                              DateFormat('hh:mm a \nEEEE');
                          final String formatted =
                              formatter.format(times).toString();
                          fconnection.saveToFirebase(titlecontroller.text,
                              descriptioncontroller.text, formatted);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ToDo added"),
                            duration: Duration(milliseconds: 1200),
                          ));
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.white60,
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black.withOpacity(0.7)),
                        //  Color(0xFF00abff)
                      ),
                    ),
                  ),
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      border:
                          Border.all(color: Colors.black87.withOpacity(0.4)),
                    ),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white60,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showbottomsheetforsortdata(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.33,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        boolsort = false;
                        sort = 'time';
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87),
                      ),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: Text(
                        "Sort by time - ascending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        boolsort = true;
                        sort = 'time';
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: Text(
                        "Sort by time - descending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        boolsort = false;
                        sort = 'title';
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: Text(
                        "Sort by title - ascending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        boolsort = true;
                        sort = 'title';
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87)),
                      padding: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      // color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: Text(
                        "Sort by title - descending",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
