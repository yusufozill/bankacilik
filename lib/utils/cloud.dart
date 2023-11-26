import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Cloud{
    /// [createAccount] firebase callable funciton
  static Future createAccount(User user) async {
    Map map = {
      "displayName": user.displayName,
      "email": user.email,
      "photoURL": user.photoURL,
      "uid": user.uid,
      "phoneNumber": user.phoneNumber,
    };
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('createTuser');
      final resp = await callable.call(map);
      print("result: ${resp.data}");
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  static getChampions() async {

  }
}