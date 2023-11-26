import 'package:flutter/material.dart';

import '../database.dart';
import '../tabs/bankalar.dart';
import '../tabs/hareket.dart';
import '../tabs/odeme_yontemleri_ekrani.dart';
import '../tabs/ozet_screen.dart';

class EkstreEkrani extends StatefulWidget {
  const EkstreEkrani({Key? key}) : super(key: key);

  @override
  _EkstreEkraniState createState() => _EkstreEkraniState();
}

class _EkstreEkraniState extends State<EkstreEkrani> {
  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget>[
    const CircularProgressIndicator(),
    const CircularProgressIndicator(),
    const CircularProgressIndicator(),
    const CircularProgressIndicator(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    Database.init().then((value) => {
          setState(() {
            _widgetOptions = [
              const TransAcitonDetailScreen(), // Home screen
              const BankalarScreen(), // Transactions screen
              const Hareketler(), // Banks screen
              const PaymentMethodsScreen(),
            ];
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Banks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'yontemler',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
