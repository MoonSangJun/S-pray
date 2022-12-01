import 'package:bottom_bar/bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:spray/rounded_button.dart';
import 'package:spray/timer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'board.dart';
import 'home.dart';
import 'login.dart';
import 'map.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({Key? key}) : super(key: key);

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.purple,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text(
                      'Spray',
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.church, color: Colors.purple.shade100),
              title: const Text('Favorite Group'),
              onTap: () {
                Navigator.pushNamed(context, '/hotel');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.person, color: Colors.purple.shade100),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/my');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.logout, color: Colors.purple.shade100),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Groups Name"), centerTitle: true,
      ),

      body: StreamBuilder(
        stream: user.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return GridView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5.0,
              ),
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                streamSnapshot.data!.docs[index];
                return Card(
                    margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                    child: Row(
                      // TODO: Center items on the card (103)
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                            child: Row(
                              // TODO: Align labels to the bottom and center (103)
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // TODO: Change innermost Column (103)
                              children: <Widget>[
                                SizedBox(
                                  width: 60,
                                  height: 40,
                                  child: Image.network(documentSnapshot['image']),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  documentSnapshot['email'].toString(),
                                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                SizedBox(width: 100),
                                Text(
                                  "number",
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 1,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "time",
                                  style: TextStyle(fontSize: 14),
                                  maxLines: 1,
                                ),
                                //const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
