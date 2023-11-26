import "package:omunotexam/firebase_options.dart";
import "package:firebase_core/firebase_core.dart";
class FirebaseEngine {
  /// [FirebaseEngine] firebase'i başlatır ve [FirebaseApp] döndürür
  static final FirebaseEngine _instance = FirebaseEngine._internal();

  factory FirebaseEngine() {
    return _instance;
  }

  FirebaseEngine._internal();
  /// [init] firebase'i başlatır ve [FirebaseApp] döndürür
  Future<FirebaseApp> init() async {
    FirebaseApp firebase=  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web,
      );

  /// [FirebaseFunctions] emulator için
        return firebase;


  }

}

