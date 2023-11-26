import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/widgets/google_sign_in_button.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ekstre_ekrani.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool girisYapildiMi = false;
  bool? created;

  @override
  void initState() {
    //print("sign in screen");
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      checkUser(user);
    });
    super.initState();
  }

  checkUser(User? user) async {
    if (user == null) {
      print("giriş yapılmadı");
      setState(() {
        girisYapildiMi = false;
      });
    } else {
      print("giriş yapıldı");
         setState(() {
          girisYapildiMi = true;
        });
    
   
   
    }
  }

  @override
  Widget build(BuildContext context) {

  
    if (girisYapildiMi) {
            return const EkstreEkrani();

    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 58,
            top: -197,
            child: Container(
              width: 737,
              height: 454,
              decoration: const ShapeDecoration(
                color: Colors.blue,
                shape: OvalBorder(
                  side: BorderSide(width: 3, color: Color(0xFF666666)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Hadi\nYarışalım',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 74,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 40),
                  child: GoogleSignInButton(callback: checkUser),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 60, top: 40, right: 60),
                      child: Text(
                        'Bir intörn arkadaştan...',
                        style: GoogleFonts.kalam(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.end,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
