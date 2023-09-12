import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthView extends StatefulWidget {
  const GoogleAuthView({super.key});

  @override
  State<GoogleAuthView> createState() => _GoogleAuthViewState();
}

class _GoogleAuthViewState extends State<GoogleAuthView> {
  var name = 'etho nari';

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        name = FirebaseAuth.instance.currentUser!.displayName.toString();
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Error();
    }
  }

  signOut() async {
    // await _googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    debugPrint('singout');
    setState(() {
      name = "etho nari";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleSignIn')),
      body: Column(
        children: [
          Text(name),
          Image.network(FirebaseAuth.instance.currentUser?.photoURL ??
              'https://source.unsplash.com/random'),
          ElevatedButton(
              onPressed: signInWithGoogle, child: const Text('Press Me')),
          ElevatedButton(
              onPressed: signOut, child: const Text('Press Me Again'))
        ],
      ),
    );
  }
}
