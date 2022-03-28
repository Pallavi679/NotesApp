// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/pages/addnote.dart';
import 'package:noteapp/pages/viewnote.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');
  List<Color> myColors = [
    Color.fromARGB(255, 228, 215, 100),
    Color.fromARGB(255, 245, 229, 182),
    Color.fromARGB(255, 241, 120, 111),
    Color.fromARGB(255, 128, 240, 132),
    Color.fromARGB(255, 162, 118, 238),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          )
              .then((value) {
            setState(() {
              print("Calling Set State");
              setState(() {});
            });
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),
        backgroundColor: Colors.grey[700],
      ),
      appBar: AppBar(
        title: Text(
          'Notes Maker',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff070706),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Random random = new Random();
                Color bg = myColors[random.nextInt(5)];
                Map data = snapshot.data!.docs[index].data();
                DateTime mydateTime = data['created'].toDate();
                String formattedTime =
                    DateFormat.yMMMd().add_jm().format(mydateTime);
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ViewNote(data, formattedTime,
                            snapshot.data!.docs[index].reference),
                      ),
                    )
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Card(
                    color: bg,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['title']}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              DateFormat.yMMMd().add_jm().format(mydateTime),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Loading......"),
            );
          }
        },
      ),
    );
  }
}
