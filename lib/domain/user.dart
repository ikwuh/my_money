import 'package:firebase_auth/firebase_auth.dart';

class MainUser{
  String id = "";

  MainUser.fromFirebase(User? user){
    if (user != null){
      id = user.uid;
    }
  }
}