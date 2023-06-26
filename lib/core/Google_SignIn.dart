import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://mail.google.com',
    'https://www.googleapis.com/auth/gmail.modify',
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.labels',
  ],
);

String? name;
String? email;
String? imageUrl;
String? phoneNo;
String? userid;
String? accessToken;
String? idToken;

Future<String?> signInWithGoogle() async {
  await Firebase.initializeApp();

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://mail.google.com',
      'https://www.googleapis.com/auth/gmail.modify',
      'https://www.googleapis.com/auth/gmail.readonly',
      'https://www.googleapis.com/auth/gmail.labels',
    ],
  );

  final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication?.accessToken,
    idToken: googleSignInAuthentication?.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);

  final User? user = authResult.user;
  print("token->"+credential.token.toString());

  if(googleSignInAuthentication!.accessToken!=null){
    accessToken=googleSignInAuthentication.accessToken.toString();
    idToken=googleSignInAuthentication.idToken.toString();
  }

  if (user != null) {
    // Checking if email and name is null
    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    assert(user.uid != null);
    final User? currentUser = _auth.currentUser;
    assert(user.uid == currentUser?.uid);

    name = user.displayName;
    email = user.email;
    imageUrl = user.photoURL;
    userid = user.uid;
    phoneNo = user.phoneNumber;

    if (name!.contains(" ")) {
      name = name!.substring(0, name!.indexOf(" "));
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    print('signInWithGoogle succeeded: $user');

    return '$user';
  }

  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Signed Out");
}
