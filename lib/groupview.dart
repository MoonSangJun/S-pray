import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spray/detail.dart';
import 'model/group.dart';

List<Group> gros = [];


class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  Future<List<Group>> getDataASC() async {
    var logger = Logger();

    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection('group');
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await collectionReference.orderBy('create_timestamp',descending: false).get();

    final List<Group> groups = [];
    for (var doc in querySnapshot.docs) {
      Group groups1 = Group.fromQuerySnapshot(doc);
      if(!gros.contains(groups1)) {
        gros.add(groups1);
      }
      groups.add(groups1);
    }
    logger.d(groups);
    return groups;
  }


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
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.group_add, color: Colors.purple.shade100),
              title: const Text('Group'),
              onTap: () {
                Navigator.pushNamed(context, '/group');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.person, color: Colors.purple.shade100),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
              leading:  Icon(Icons.logout, color: Colors.purple.shade100),
              title: const Text('Log Out'),
              onTap: () async {
                Navigator.pushNamed(context, '/login');
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Group"), centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.add,
                semanticLabel: 'search',
              ),
              onPressed: () => {Navigator.pushNamed(context, '/add')}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Group>>(
                future: getDataASC(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Group> datas = snapshot.data!;
                    return
                      GridView.builder(
                      itemCount: datas.length,
                      itemBuilder: (BuildContext context, int index) {
                        Group data = datas[index];

                        return Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    AspectRatio(
                                        aspectRatio: 18 / 11,
                                        child: Image.network(data.image!)),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              data.name!,
                                              maxLines: 1,
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(" ${data.description}"),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  child: const Text("more"),
                                                  style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    minimumSize: Size.zero,
                                                    textStyle: const TextStyle(
                                                        fontSize: 10,
                                                        overflow:
                                                        TextOverflow.ellipsis),
                                                    tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                  ),
                                                  onPressed: () => {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailPage(prods: datas[index],
                                                                )))
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 8 / 9,
                      ),
                    );
                  }
                  else if (snapshot.hasError) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(fontSize: 15),
                        ));
                  }
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )

        ],
      )

    );
  }
}
