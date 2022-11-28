import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
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
        title: const Text("Group"), centerTitle: true,
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
              .collection('group')
              .doc(group.id.toString())
              .snapshots()
              builder: builder
          )
        ],
      )

    );
  }
}
