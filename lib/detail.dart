import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/group.dart';

class DetailPage extends StatefulWidget with ChangeNotifier {
  DetailPage({Key? key, required this.prods}) : super(key: key);

  final Group prods;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  final db = FirebaseFirestore.instance;

  final _uid = FirebaseAuth.instance.currentUser!.uid;

  var docID;

  static final productRef = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    super.initState();
    docID = widget.prods.uid.toString();
  }

  void userLike() async {
    final docRef = db.collection('users').doc(_uid);
    //현재 접속한 user의 정보 가져오기 그 중 like 추출
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        var userLiked = data['like'];
        print(userLiked.toString());
        if (userLiked == 0) {
          // 만약 user_liked 가 0 이면 1로 업데이트한다.
          db.runTransaction((transaction) async {
            transaction.update(docRef, {'like': 1});
          }).then(
                (value) {
              var snackbar = SnackBar(
                content: Text("I LIKE IT"),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              print("This users clicked like!");
            },
            onError: (e) => print("Error updating document $e"),
          );
        } else {
          print("NOWay!");
          var snackbar = SnackBar(content: Text("You can only do it once!"));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  //전체 Users의 like의 개수를 모두 세어서, 리턴한다. 이걸 나중에 업데이트도 해줘야 한다.
  //products에 업데이트 하는 코드 추가


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prods.name!),

      ),
      body:
      SingleChildScrollView(
        child: Column(
            children: [
              Image.network(widget.prods.image!),
              Text(widget.prods.name!),
              Text(widget.prods.description!),
              Text("creator : < ${widget.prods.uid} >"),
              Text("${(widget.prods.create_t)?.toDate()} Created"),
              Container(
                height: 100,
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('group')
                                .doc(widget.prods.name)
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              // liked를 가져올 likedArray 생성
                              List<dynamic> likedArray = snapshot.data!.get('liked');
                              if (snapshot.data != null) {
                                final alreadySaved = likedArray.contains(FirebaseAuth.instance.currentUser!.uid);
                                return Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (alreadySaved) {
                                            FirebaseFirestore.instance
                                                .collection('group')
                                                .doc(widget.prods.name)
                                                .update({
                                              'liked': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
                                            });

                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .update({
                                              'liked': FieldValue.arrayRemove([widget.prods.name])

                                            });

                                            var snackbar = const SnackBar(
                                              content: Text("그룹에서 탈퇴하였습니다."),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackbar);



                                          }
                                          // 파베에 없는 경우 array 에 update 시킨다. 스낵바 표시
                                          else {
                                            FirebaseFirestore.instance
                                                .collection('group')
                                                .doc(widget.prods.name)
                                                .update({
                                              'liked': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
                                            });

                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                                .update({
                                              'liked': FieldValue.arrayUnion([widget.prods.name])

                                            });

                                            var snackbar = const SnackBar(content: Text("그룹에 추가되었습니다!"));
                                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                          }
                                        });
                                        //파베에 있는 경우 스낵바 표시

                                      },
                                      icon: Icon(
                                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                                        color: alreadySaved ? Colors.purple : null,
                                        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                                      ),
                                    ),
                                    Text('${likedArray.length}'),
                                  ],
                                );
                              }
                              else if (snapshot.hasError){
                                return const Center(child: CircularProgressIndicator());
                              }
                              else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }),
                      ),
              Container(
                height: 500,
                child: StreamBuilder(
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
              )

            ]),
      ),
    );
  }
}
