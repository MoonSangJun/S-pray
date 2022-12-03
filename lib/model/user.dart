import 'package:cloud_firestore/cloud_firestore.dart';


class Users  {

  Users({
    this.email,
    this.status_message,
    this.image,
    this.uid,
    this.name,
    this.liked,

  });

  String? email;
  String? uid;
  String? image;
  String? name;
  String? status_message;
  List<dynamic>? liked;

  DocumentReference? reference;

  Users.fromJson(dynamic json, this.reference){
    uid = json['uid'];
    image = json['image'];
    name = json['name'];
    status_message = json['status_message'];
    email = json['email'];
    liked = json['liked'];

  }


  Users.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);

}