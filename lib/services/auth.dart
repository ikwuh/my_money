import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_money/domain/user.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  dynamic user;
  String userEmail = "";
  void getCurrentUserInfo() async {
    user = await _fAuth.currentUser!.email;
    userEmail = user;
  }

  void changePassword(String email) async {
    _fAuth.sendPasswordResetEmail(email: email);
  }

  Future<MainUser?> singnInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return MainUser.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<MainUser?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return MainUser.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future LogOut() async {
    await _fAuth.signOut();
  }

  Stream<MainUser?> get currentUser {
    return _fAuth
        .authStateChanges()
        .map((User? user) => user != null ? MainUser.fromFirebase(user) : null);
  }
}
