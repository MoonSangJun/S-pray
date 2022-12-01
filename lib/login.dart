import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['profile', 'email']).signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // return await FirebaseAuth.instance.signInWithCredential(credential);

    final data = await FirebaseAuth.instance.signInWithCredential(credential);
    await FirebaseFirestore.instance.collection('users').doc(data.user!.uid).set({
      'name' : data.user!.displayName,
      'email': data.user!.email,
      'uid': data.user!.uid,
      'image': data.user!.photoURL,
      'praynumber':"0",
    }, SetOptions(merge : true));
    return data.user;
  }

  Future<User?> signInWithAnonymously() async {
    final data = await FirebaseAuth.instance.signInAnonymously();

    await FirebaseFirestore.instance.collection('users').doc(data.user!.uid).set({
      'email': 'Anonymous',
      'uid': data.user!.uid,
      'image': 'http://handong.edu/site/handong/res/img/logo.png',
      'status_message' : 'I promise to take the test honestly before GOD.',
      'praynumber':"0",
    }, SetOptions(merge : true));
    return data.user;
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                const Text('SPRAY'),
              ],
            ),
            const SizedBox(height: 120.0),
            ElevatedButton(
              onPressed: () {
                signInWithGoogle().then((value) =>
                    Navigator.pushNamed(context,'/')
                );

              },
              child: const Text('Google SIGN IN'),
            ),
            ElevatedButton(
              onPressed: () {
                signInWithAnonymously().then((value) =>
                    Navigator.pushNamed(context,'/members')

                );
              },
              child: const Text('Anonymous'),
            ),
          ],
        ),
      ),
    );
  }
}
