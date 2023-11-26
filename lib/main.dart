import "package:flutter/material.dart";
import "package:omunotexam/screens/sign_in_screen.dart";
import "package:omunotexam/tabs/bankalar.dart";
import "package:omunotexam/utils/firebase_connections.dart";

import "screens/ekstre_ekrani.dart";



Future<void> main() async {
  //print("en azindan calistim");
  WidgetsFlutterBinding.ensureInitialized();
 await  FirebaseEngine().init();
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      routes: {
        
        "/": (context) =>  const SignInScreen(),
            
       // "/home": (context) => const HomePage(),
      },
    );
  }
}
