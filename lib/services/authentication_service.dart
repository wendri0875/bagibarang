import 'package:bagi_barang/locator.dart';
import 'package:bagi_barang/models/user.dart';
import 'package:bagi_barang/services/FirestoreService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FirestoreService _firestoreService = locator<FirestoreService>();

    FirebaseUser _currentFirebaseUser;
  FirebaseUser get currentFirebaseUser => _currentFirebaseUser;

  Future loginWithEmail({@required String email, @required String password}) {
    // TODO: implement loginWithEmail
    return null;
  }

  Future signUpWithEmail({@required String email, @required String password}) {
    // TODO: implement signUpWithEmail
    return null;
  }

  Future firebaseSignInwithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      AuthResult result =
          (await _firebaseAuth.signInWithCredential(credential));

     // FirebaseUser user = result.user;
   //    _currentFirebaseUser = await _firebaseAuth.currentUser();

   _currentFirebaseUser =result.user;

      //return user.uid;
      return _currentFirebaseUser != null;
    } catch (e) {
      return e.message;
    }
  }

  Future firebaseSignOut() async {
    try {
      // GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      // GoogleSignInAuthentication googleSignInAuthentication =
      //     await googleSignInAccount.authentication;

      // AuthCredential credential = GoogleAuthProvider.getCredential(
      //     idToken: googleSignInAuthentication.idToken,
      //     accessToken: googleSignInAuthentication.accessToken);

      _firebaseAuth.signOut();
      return true;
  
      //return user.uid;

    } catch (e) {
      return e.message;
    }
  }

  // Future<bool> isUserLoggedIn() async {
  //   var user = await _firebaseAuth.currentUser();
  //   await getFirebaseUser();
  //   return user != null;
  // }



  Future<bool> isUserLoggedIn() async {
    _currentFirebaseUser = await _firebaseAuth.currentUser();
    return _currentFirebaseUser != null;
  }


  User _currentUser;
  User get currentUser => _currentUser;

  Future _populateCurrentUser(FirebaseUser user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }



  // Future getFirebaseUser() async {
  //   _currentFirebaseUser = await _firebaseAuth.currentUser();
  // }
}
