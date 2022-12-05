import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<Users> getUser(String userkey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection('users').doc(userkey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    Users user = Users.fromSnapshot(documentSnapshot);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Profile"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.exit_to_app,
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/login');
                await FirebaseAuth.instance.signOut();
              }),
        ],
      ),
      body: FutureBuilder<Users>(
        future: getUser(_uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Users data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Container(
                  width: 300,
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      data.image!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(children: [
                      const Divider(
                        height: 40,
                        thickness: 1,
                        color: Colors.deepPurpleAccent,
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        "Chanhwi Lee",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Email: ${data.email!}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text("Pray Count: ${data.praynumber}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                      const SizedBox(height: 30),
                      Text("UID: ${data.uid!}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                      const SizedBox(height: 50),
                    ]))
              ],
            );
          } else if (snapshot.hasError) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
