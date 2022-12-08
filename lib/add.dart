import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'model/group.dart';
import 'model/user.dart';


class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}


class _AddPageState extends State<AddPage> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  String imageUrl= 'https://mblogthumb-phinf.pstatic.net/MjAxNzA2MThfODEg/MDAxNDk3NzExNzEzODM3.prLxdRgEPcgdHtuCpSb_oq1dFOMOs3XmcJYfc6e4dEkg.YYczrm92ql7i7kO8EaRzy3Hr8ysxYVymceHeVORLhwgg.JPEG.charis628/1496480599234.jpg?type=w800';


  List<bool> _isChecked = [
    false,  // 서울/경기
    false,  // 강원도
    false,  // 충청도
    false,  // 전라도
    false,  // 경상도
    false,  // 제주도
  ];

  List<String> _selected =[
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  String? _location;

  //count the documents


  //upload images to Storage
  uploadImage() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance.collection('group').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    var count = _myDocCount.length;
    print(_myDocCount.length);
    final _firebaseStorage = FirebaseStorage.instance;
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    var file = File(image!.path);

    var snapshot =
    await _firebaseStorage.ref().child('images/group-$count').putFile(file);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageUrl = downloadUrl;
    });

  }

  //Create products data to Firestore Database.

  List<Users>? list = [];

  final db = FirebaseFirestore.instance;

  void groupSession() async {
    final now = FieldValue.serverTimestamp();
    imageUrl == null ? imageUrl = "https://mblogthumb-phinf.pstatic.net/MjAxNzA2MThfODEg/MDAxNDk3NzExNzEzODM3.prLxdRgEPcgdHtuCpSb_oq1dFOMOs3XmcJYfc6e4dEkg.YYczrm92ql7i7kO8EaRzy3Hr8ysxYVymceHeVORLhwgg.JPEG.charis628/1496480599234.jpg?type=w800" : null;
    Group group = Group(
      uid: _uid,
      image: imageUrl,
      name: _name.text,
      description: _description.text,
      location: _location,
      create_timestamp: now,
      liked : list,
    );
    final docRef = db.collection('group').doc(group.name);

    FirebaseFirestore.instance
        .collection('pray')
        .doc('praySet')
        .update(
        {
          'prayTitle': FieldValue.arrayUnion([_description.text])
        }
    );


    await docRef.set(group.toJson()).then(
            (value) => log("group uploaded successfully!"),
        onError: (e) => log("Error while uploading!"));
    Navigator.pushNamed(context,'/group');
  }


  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };

      if (states.any(interactiveStates.contains)) {
        return Colors.deepPurple;
      }
      return Colors.deepPurple;
    }

    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.purple,

          leading: TextButton(
            child: Text("Cancel",style: TextStyle(color: Colors.white,fontSize: 10),),
            onPressed: () {
              Navigator.pushNamed(context,'/home');
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

        body:

        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(50),
                  child: (imageUrl != null)
                      ? Image.network(imageUrl)
                      : Image.network(
                      'https://mblogthumb-phinf.pstatic.net/MjAxNzA2MThfODEg/MDAxNDk3NzExNzEzODM3.prLxdRgEPcgdHtuCpSb_oq1dFOMOs3XmcJYfc6e4dEkg.YYczrm92ql7i7kO8EaRzy3Hr8ysxYVymceHeVORLhwgg.JPEG.charis628/1496480599234.jpg?type=w800')),
              Row(
                children: [
                  IconButton(onPressed: uploadImage, icon: Icon(Icons.camera_alt))
                ],
              ),
              const SizedBox(height: 5.0),

              Row(
                children: <Widget>[
                  Expanded(child: Card(child: Column(children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: '그룹이름',
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:
                      Row(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor),
                                value: _isChecked[0],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked[0] = value!;

                                    if(_isChecked[0]){
                                      _location = "서울/경기";
                                    }

                                    else
                                      _selected[0] = "";
                                  });
                                },
                              ),
                              Text("서울/경기")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor),
                                value: _isChecked[1],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked[1] = value!;

                                    if(_isChecked[1]){
                                      _location ="강원도";
                                    }
                                    else
                                      _selected[1] ="";
                                  });
                                },
                              ),
                              Text("강원도")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor),
                                value: _isChecked[2],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked[2] = value!;

                                    if(_isChecked[2]){
                                      _location = "충청도";
                                    }

                                    else
                                      _selected[2] ="";
                                  });
                                },
                              ),
                              Text("충청도")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor),
                                value: _isChecked[3],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked[3] = value!;

                                    if(_isChecked[3]){
                                      _location = "전라도";

                                    }
                                    else
                                      _selected[3] ="";
                                  });
                                },
                              ),
                              Text("전라도")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor),
                                value: _isChecked[4],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked[4] = value!;

                                    if(_isChecked[4]){
                                      _location = "경상도";
                                    }
                                    else
                                      _selected[4] ="";
                                  });
                                },
                              ),
                              Text("경상도")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getColor),
                                value: _isChecked[5],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked[5] = value!;

                                    if(_isChecked[5]){
                                      _location = "제주도";
                                    }
                                    else
                                      _selected[5] ="";
                                  });
                                },
                              ),
                              Text("제주도")
                            ],
                          ),

                        ],
                      ),
                    ),

                    TextField(
                      controller: _description,
                      decoration: InputDecoration(
                        labelText: '기도제목',
                      ),
                    ),
                  ],),))

                ],
              ),

            ],
          ),
        ),
        resizeToAvoidBottomInset: true
    );
  }
}
