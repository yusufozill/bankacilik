import 'package:flutter/material.dart';

import '../classes/banka.dart';
import '../classes/odeme_yontemleri.dart';
import '../database.dart';


class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _addCreditCard(
    int sonOdemeTarihi,
    int hesapKesimTarihi,
    double krediKartiLimiti,
    double eksiParaBakiyesi,
    String cardNumber,
    Banka bankName,
    String paraBirimi,
    String type,
    String name,
    String summary,
  ) {
    CreditCard newCard = CreditCard(
      sonOdemeTarihi: sonOdemeTarihi,
      krediKartiLimiti: krediKartiLimiti,
      eksiParaBakiyesi: eksiParaBakiyesi,
      hesapKesimTarihi: hesapKesimTarihi,
      cardNumber: cardNumber,
      bankName: bankName,
      paraBirimi: paraBirimi,
      type: type,
      name: name,
      summary: summary,
    );
    Database.sendPaymentMethod(newCard);
    setState(() {});
  }

  void _addDebitCard(
    double availableBalance,
    double additionalBalance,
    String cardNumber,
    Banka bankName,
    String paraBirimi,
    String type,
    String name,
    String summary,
  ) {
    DebitCard debitCard = DebitCard(
      availableBalance: availableBalance,
      additionalBalance: additionalBalance,
      cardNumber: cardNumber,
      bankName: bankName,
      paraBirimi: paraBirimi,
      type: type,
      name: name,
      summary: summary,
    );
    Database.sendPaymentMethod(debitCard);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ödeme Yöntemleri'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Kredi Kartları',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Database.paymentMethods.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Database.paymentMethods.values
                      .toList()[index]
                      .toWidget(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var _cardNumber = '';
              Banka _bankName =
                  Database.bankAccounts.values.toList()[0];
              var _paraBirimi = 'TRY';
              var _type = 'Kredi Kartı';
              var _availableBalance = 0.0;
              var _additionalBalance = 0.0;
              var _eksiParaBakiyesi = 0.0;
              var _sonOdemeTarihi = 1;
              var _hesapKesimTarihi = 1;

              var _name = '';
              var _summary = '';

              var _krediKartiLimiti = 0.0;

              return AlertDialog(
                title: const Text('Kart Ekle'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Kart Numarası',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _cardNumber = value;
                          });
                        },
                      ),
                     _type!='Kredi Kartı'?SizedBox(): TextField(
                        decoration: const InputDecoration(
                          labelText: 'Ekstre günü',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _hesapKesimTarihi = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                     _type!='Kredi Kartı'?TextField(
                        decoration: const InputDecoration(
                          labelText: 'Kullanılabilir Bakiye',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _availableBalance = double.parse(value);
                         
                          });
                        },
                      ):  TextField(
                        decoration: const InputDecoration(
                          labelText: 'Son ödeme günü',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _sonOdemeTarihi = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    _type!='Kredi Kartı'?TextField(
                        decoration: const InputDecoration(
                           labelText: 'Ek Bakiye',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _additionalBalance = double.parse(value);
                          });
                        },
                      ):   TextField(
                        decoration: const InputDecoration(
                          labelText: 'Kredi Kartı Limiti',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _krediKartiLimiti = double.parse(value);
                          });
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Kart Adı',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Özet',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _summary = value;
                          });
                        },
                      ),
                      DropdownButtonFormField<Banka>(
                        value: _bankName,
                        decoration: const InputDecoration(
                          labelText: 'Banka',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _bankName = value!;
                          });
                        },
                        items: Database.bankAccounts.values
                            .toList()
                            .map<DropdownMenuItem<Banka>>((Banka banka) {
                          return DropdownMenuItem<Banka>(
                            value: banka,
                            child: Text(banka.bankName),
                          );
                        }).toList(),
                      ),
                      DropdownButtonFormField<String>(
                        value: _paraBirimi,
                        decoration: const InputDecoration(
                          labelText: 'Para Birimi',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _paraBirimi = value!;
                          });
                        },
                        items: <String>['TRY', 'USD', 'EUR', 'GBP']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      DropdownButtonFormField<String>(
                        value: _type,
                        decoration: const InputDecoration(
                          labelText: 'Kart Türü',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                          });
                        },
                        items: <String>['Kredi Kartı', 'Debit Kart']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                    TextButton(
                    child: const Text('yenile'),
                    onPressed: () {
                      setState(() {
                        print(_type);
                      });
                    },
                  ),
                  TextButton(
                    child: const Text('Kapat'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Ekle'),
                    onPressed: () {
                      if (_type == 'Kredi Kartı') {
                        _addCreditCard(
                          _sonOdemeTarihi,
                          _hesapKesimTarihi,
                          _krediKartiLimiti,
                          _eksiParaBakiyesi,
                          _cardNumber,
                          _bankName,
                          _paraBirimi,
                          _type,
                          _name,
                          _summary,
                        );
                      } else if (_type == 'Debit Kart') {
                        _addDebitCard(
                          _availableBalance,
                          _additionalBalance,
                          _cardNumber,
                          _bankName,
                          _paraBirimi,
                          _type,
                          _name,
                          _summary,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

