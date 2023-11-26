import 'package:flutter/material.dart';

import '../classes/banka.dart';
import '../database.dart';

class BankalarScreen extends StatefulWidget {
  const BankalarScreen({Key? key}) : super(key: key);

  @override
  _BankalarScreenState createState() => _BankalarScreenState();
}

class _BankalarScreenState extends State<BankalarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNameController = TextEditingController();
  final _accountBalanceController = TextEditingController();
  final _flexibleAccountBalanceController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountBalanceController.dispose();
    _flexibleAccountBalanceController.dispose();
    super.dispose();
  }

  void _showAddBankAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Banka Hesabı Ekle'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: 'Banka İsmi',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir banka ismi girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _accountBalanceController,
                  decoration: const InputDecoration(
                    labelText: 'Hesap Bakiyesi',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir hesap bakiyesi girin';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Lütfen geçerli bir sayı girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _flexibleAccountBalanceController,
                  decoration: const InputDecoration(
                    labelText: 'Esnek Hesap Bakiyesi',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir hesap bakiyesi girin';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Lütfen geçerli bir sayı girin';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newBankAccount = Banka(
                    bankName: _bankNameController.text,
                    accountBalance: double.parse(_accountBalanceController.text),
                    flexibleAccountBalance: double.parse(_flexibleAccountBalanceController.text),
                  );
                  setState(() {
                    Database.bankAccounts.addAll({newBankAccount.bankName: newBankAccount});
                    Database.sendBankAccount(newBankAccount.bankName, newBankAccount.accountBalance, newBankAccount.flexibleAccountBalance);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bankalar'),
      ),
      body: Database.bankAccounts.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: Database.bankAccounts.length,
              itemBuilder: (context, index) {
                
                
                return
                Dismissible(
            key: Key(Database.bankAccounts.values.toList()[index].bankName),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // Düzenleme işlemi
                // TODO: Implement düzenleme işlemi
              } else if (direction == DismissDirection.startToEnd) {
                // Silme işlemi
              }
            },
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.blue,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: 
                 Database.bankAccounts.values.toList()[index].toWidget(),
            
             );

              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddBankAccountDialog(context);
        },
      ),
    );
  }
}
