import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  TodoCard(
      {Key? key,
      this.title,
      this.utitle,
      this.udesc,
      this.snap,
      this.weekday,
      this.indexx,
      this.description,
      this.time})
      : super(key: key);

  final String? title;
  final String? description;
  final dynamic time;
  final dynamic weekday;
  final String? utitle;
  final String? udesc;
  final int? indexx;
  final AsyncSnapshot<QuerySnapshot<Object?>>? snap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      closeOnScroll: true,
      secondaryActions: [
        IconSlideAction(
          color: Colors.grey[50],
          caption: "Edit",
          icon: Icons.edit,
          onTap: () {
            showUpdatenoteDialog(context);
          },
        ),
        IconSlideAction(
          color: Colors.grey[50],
          caption: "Delete",
          icon: Icons.delete_forever,
          onTap: () {
            snap!.data!.docs[indexx!].reference.delete();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Deleted")));
          },
        ),
      ],
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[300],
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "$title",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                            fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "$description",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, bottom: 5),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        //color: Colors.amber,
                        child: Text(
                          "$time",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                              color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showUpdatenoteDialog(
    BuildContext context,
  ) {
    TextEditingController utitlecontroller = TextEditingController();
    TextEditingController udescriptioncontroller = TextEditingController();
    utitlecontroller.text = "$utitle";
    udescriptioncontroller.text = "$udesc";
    showCupertinoDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(child: Text("Update Note")),
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
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: utitlecontroller,
                        // keyboardType: TextInputType.name,
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
                        keyboardType: TextInputType.multiline,
                        controller: udescriptioncontroller,
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
                        //update ToDos
                        DateTime times = DateTime.now();
                        final DateFormat formatter =
                            DateFormat('hh:mm a \nEEEE');
                        final String formatted =
                            formatter.format(times).toString();

                        snap!.data!.docs[indexx!].reference
                            .update(({
                          "title": utitlecontroller.text,
                          "description": udescriptioncontroller.text,
                          "time": formatted
                        }))
                            .whenComplete(() {
                          Navigator.pop(context);
                          print("updated todo");
                        });
                        // print("updated todo");
                      },
                      color: Colors.white60,
                      child: Text(
                        "Update",
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
}
