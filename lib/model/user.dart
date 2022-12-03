import 'package:cloud_firestore/cloud_firestore.dart';


class Users  {

  Users({
    this.email,
    this.status_message,
    this.image,
    this.uid,
    this.name,
    this.like,

  });

  String? email;
  String? uid;
  String? image;
  String? name;
  String? status_message;
  int? like;

  DocumentReference? reference;

  Users.fromJson(dynamic json, this.reference){
    uid = json['uid'];
    image = json['image'];
    name = json['name'];
    status_message = json['status_message'];
    email = json['email'];
    like = json['like'];

  }


  Users.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);

}