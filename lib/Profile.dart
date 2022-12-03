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
    DocumentReference<Map<String,dynamic>> documentReference =
        FirebaseFirestore.instance.collection('users').doc(userkey);
    final DocumentSnapshot<Map<String,dynamic>> documentSnapshot =
        await documentReference.get();
    Users user = Users.fromSnapshot(documentSnapshot);
    return user;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.exit_to_app,
              ),
              onPressed: () async  {
                Navigator.pushNamed(context, '/login');
                await FirebaseAuth.instance.signOut();
  }),
        ],
      ),
      body: FutureBuilder<Users>(
        future: getUser(_uid),
        builder: (context, snapshot){
          if(snapshot.hasData){
            Users data = snapshot.data!;
            return Column(
              children: [
                Container(
                  child: Image.network(data.image!),
                ),
                Text("UID: ${data.uid!}"),
                Text("Email: ${data.email!}"),
                Text("Chanhwi Lee"),
                SizedBox(height: 8.0,),
                Text("I promise to take the test honestly before GOD")
              ],

            );
          }
          else if(snapshot.hasError){
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child : Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                )
            );
          }

          else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),


    );
  }
}
