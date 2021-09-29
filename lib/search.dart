import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_firebase/searchToDoCard.dart';

class ListSearch extends SearchDelegate<String> {
  // late final List<String> names;

  // ListSearch(this.names);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("ToDos")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // print(snapshot.data!.docs[0]['title']);
            if (snapshot.data == null || !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              var tempRes = [];
              snapshot.data!.docs.forEach((element) {
                if (element["title"]
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  tempRes.add(element);
                }
              });

              var result = snapshot.data!.docs.where(
                  (DocumentSnapshot element) => element['title']
                      .toLowerCase()
                      .contains(query.toLowerCase()));
              print("search result is $result");
              // ignore: unnecessary_null_comparison
              if (result == null) {
                return Center(
                  child: Text("No Search Result"),
                );
              }
              return Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tempRes.length,
                    itemBuilder: (context, index) {
                      return SearchToDoCard(
                        title: tempRes[index]['title'],
                        description: tempRes[index]['description'],
                        time: tempRes[index]['time'],
                        uutitle: tempRes[index]['title'],
                        uudesc: tempRes[index]['description'],
                        indexxx: index,
                        snap: snapshot,
                      );
                    }),
              );
            }
          });
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("ToDos")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // print(snapshot.data!.docs[0]['title']);
          if (snapshot.data == null || !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var tempsuggestion = [];
            snapshot.data!.docs.forEach((element) {
              if (element["title"]
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                tempsuggestion.add(element);
              }
            });

            var result = snapshot.data!.docs.where((DocumentSnapshot element) =>
                element['title'].toLowerCase().contains(query.toLowerCase()));
            print("search result is $result");
            // ignore: unnecessary_null_comparison
            if (result == null) {
              return Center(
                child: Text("No Search Result"),
              );
            }
            return SingleChildScrollView(
              child: Container(
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tempsuggestion.length,
                    itemBuilder: (context, index) {
                      return SearchToDoCard(
                        title: tempsuggestion[index]['title'],
                        description: tempsuggestion[index]['description'],
                        time: tempsuggestion[index]['time'],
                        uutitle: tempsuggestion[index]['title'],
                        uudesc: tempsuggestion[index]['description'],
                        snap: snapshot,
                        indexxx: index,
                      );

                      // ListTile(
                      //   title: Text(tempRes[index]['title']),
                      //   subtitle: Text(tempRes[index]['description']),
                      // );
                    }),
              ),
            );
          }
        });
  }
}
