import 'package:fluttemons/pokemon_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../datastrore/pokemon_firestore.dart';

class SignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
      //
      !PokemonFireStore.userExists()
          ? await PokemonFireStore.addUserData()
          : userData = await PokemonFireStore.getUserData();
      //
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    try {
      googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}