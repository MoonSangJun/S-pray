// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';


class Group  {

  Group({
    this.uid,
    this.image,
    this.name,
    this.description,
    this.create_timestamp,
    this.create_t,
    this.modify_t,
    this.liked,
    this.reference,

  });

  String? uid;
  String? image;
  String? name;
  String? description;
  FieldValue? create_timestamp;
  Timestamp? create_t;
  Timestamp? modify_t;
  List<dynamic>? liked;
  DocumentReference? reference;

  Group.fromJson(dynamic json, this.reference){
    uid = json['uid'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    create_t = json['create_timestamp'];
    liked = json['liked'];

  }

  Map<String, dynamic> toJson() => {
    "uid" : uid,
    "image" : image,
    "name" : name,
    "description" : description,
    "create_timestamp" : create_timestamp,
    'liked' : liked,
  };

  Group.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(),snapshot.reference);

}





