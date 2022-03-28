import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  // const ViewNote({Key? key}) : super(key: key);
  final Map data;
  final String time;
  final DocumentReference ref;

  // ignore: use_key_in_widget_constructors
  const ViewNote(this.data, this.time, this.ref);

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String description;
  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    description = widget.data['description'];
    return SafeArea(
      child: Scaffold(
        //edit
        floatingActionButton: edit
            ? FloatingActionButton(
                onPressed: save,
                child: Icon(
                  Icons.save_rounded,
                  color: Colors.white70,
                ),
                backgroundColor: Colors.grey[700],
              )
            : null,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[700]),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            size: 24.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey[700]),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        ElevatedButton(
                          onPressed: delete,
                          child: Icon(
                            Icons.delete_forever,
                            size: 24.0,
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red[300]),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                        },
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return null;
                          } else {
                            return "Can't be empty";
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          "${widget.time}",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: TextFormField(
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                          initialValue: widget.data['description'],
                          enabled: edit,
                          onChanged: (_val) {
                            description = _val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delete() async {
    widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    await widget.ref.update(
      {"title": title, "description": description},
    );
    Navigator.of(context).pop();
  }
}
