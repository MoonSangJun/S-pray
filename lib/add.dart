import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'model/group.dart';


class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}


class _AddPageState extends State<AddPage> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  String imageUrl= 'http://handong.edu/site/handong/res/img/logo.png';


  //count the documents


  //upload images to Storage
  uploadImage() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('products').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    var count = _myDocCount.length;
    print(_myDocCount.length);
    final _firebaseStorage = FirebaseStorage.instance;
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    var snapshot =
    await _firebaseStorage.ref().child('images/product-$count').putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl;
    });

  }

  //Create products data to Firestore Database.

  List<String>? list = [];

  final db = FirebaseFirestore.instance;

  void groupSession() async {
    final now = FieldValue.serverTimestamp();
    imageUrl == null ? imageUrl = "http://handong.edu/site/handong/res/img/logo.png" : null;
    Group group = Group(
      uid: _uid,
      image: imageUrl,
      name: _name.text,
      description: _description.text,
      create_timestamp: now,
      liked : list,
    );
    final docRef = db.collection('group').doc(group.name);
    await docRef.set(group.toJson()).then(
            (value) => log("Products uploaded successfully!"),
        onError: (e) => log("Error while uploading!"));
    Navigator.pushNamed(context,'/');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(

          leading: TextButton(
            child: Text("Cancel",style: TextStyle(color: Colors.white,fontSize: 10),),
            onPressed: () {
              Navigator.pushNamed(context,'/');
            },
          ),
          title: Text('Add'),
          centerTitle: true,

          actions: <Widget>[
            IconButton(
              icon: Text('Save'),
              onPressed: groupSession,
            )
          ],
        ),

        body: Column(
          children: [
            Container(
                margin: EdgeInsets.all(50),
                child: (imageUrl != null)
                    ? Image.network(imageUrl)
                    : Image.network(
                    'http://handong.edu/site/handong/res/img/logo.png')),
            Row(
              children: [
                IconButton(onPressed: uploadImage, icon: Icon(Icons.camera_alt))
              ],
            ),
            const SizedBox(height: 5.0),

            Row(
              children: <Widget>[
                Flexible(child: Card(child: Column(children: [
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                    ),
                  ),
                  TextField(
                    controller: _price,
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                  TextField(
                    controller: _description,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ],),))

              ],
            ),

          ],
        ),
        resizeToAvoidBottomInset: false

    );
  }
}
