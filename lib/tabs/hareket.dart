import 'package:flutter/material.dart';
import '../classes/fonksiyonlar.dart';
import '../classes/odeme_yontemleri.dart';
import '../classes/transaction.dart';
import '../database.dart';
import '../widgets/date_time_picker.dart';

class Hareketler extends StatefulWidget {
  const Hareketler({Key? key}) : super(key: key);

  @override
  _HareketlerState createState() => _HareketlerState();
}

class _HareketlerState extends State<Hareketler> {
  @override
  void initState() {
    super.initState();
  }

  void _ekleHareket({Transaction? hareket}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _income = false;
        double _tutar = 0;
        List<PaymentMethod> _paymentMethods =
            Database.paymentMethods.values.toList();

        PaymentMethod _payment = _paymentMethods.isNotEmpty
            ? _paymentMethods[0]
            : PaymentMethod.random();
        int _taksit = 0;
        int _erteleme = 0;
        String _aciklama = "Diğer";
        String _sektor = "Diğer";
        DateTime _tarih = DateTime.now();
        String _title = hareket!=null?"Hareketi Düzenle": "Yeni Hareket Ekle";

        
        if(hareket!=null){
          _income = hareket.isGelirMi;
          _tutar = hareket.tutar;
          _payment = hareket.odemeYontemi;
          _taksit = hareket.taksitSayisi;
          _erteleme = hareket.ertelemeSayisi;
          _aciklama = hareket.aciklama;
          _sektor = hareket.sektor;
          _tarih = hareket.timestamp;
        }
        return AlertDialog(
          title: Text(_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                DropdownButtonFormField<PaymentMethod>(
                  value: _payment,
                  decoration: const InputDecoration(
                    labelText: 'Kart',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _payment = value!;
                    });
                  },
                  items: _paymentMethods.map<DropdownMenuItem<PaymentMethod>>(
                      (PaymentMethod method) {
                    return DropdownMenuItem<PaymentMethod>(
                      value: method,
                      child: Text(method.name),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<bool>(
                  value: _income,
                  decoration: const InputDecoration(
                    labelText: 'Gelir',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _income = value!;
                    });
                  },
                  items:
                      [true, false].map<DropdownMenuItem<bool>>((bool method) {
                    return DropdownMenuItem<bool>(
                      value: method,
                      child: Text(method ? 'Gelir' : 'Gider'),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: TextEditingController(
                      text: _tutar == 0 ? '' : _tutar.toString()),
                  decoration: const InputDecoration(
                    labelText: 'Tutar',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _tutar = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(
                      text: _taksit == 0 ? '' : _taksit.toString()),
                  decoration: const InputDecoration(
                    labelText: 'Taksit Sayısı',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _taksit = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(
                      text: _erteleme == 0 ? '' : _erteleme.toString()),
                  decoration: const InputDecoration(
                    labelText: 'Erteleme Sayısı',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _erteleme = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(text: _aciklama),
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _aciklama = value;
                    });
                  },
                ),
                TextField(
                  controller: TextEditingController(text: _sektor),
                  decoration: const InputDecoration(
                    labelText: 'Sektör',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _sektor = value;
                    });
                  },
                ),
                DateTimeRow(

                  value: _tarih,
                  onChanged: (value) {
                    setState(() {
                      _tarih = value;
                    });
                  },
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                if (_tutar != 0) {
                  var x = 0;
                  while (_erteleme > 0) {
                    print("$_erteleme erteleme");

                    // Ertelenmiş taksitler için

                    if (_payment
                        .ekstreKesimTarihi(_tarih)
                        .isAfter(_tarih)) {
                      _tarih = _payment
                          .ekstreKesimTarihi(_tarih)
                          .add(const Duration(days: 1));
                    } else {
                      _tarih = _payment
                          .sonrakiEkstre(_tarih)
                          .add(const Duration(days: 1));
                    }
                    _erteleme--;
                  }

                  while (x < _taksit) {
                    print("$_taksit taksit");
                    var taksitTutar = _tutar / _taksit;
                    var _taksitTarih = _tarih;
                    if (_payment
                        .ekstreKesimTarihi(_tarih)
                        .isAfter(_tarih)) {
                      _tarih = _payment
                          .ekstreKesimTarihi(_tarih)
                          .add(const Duration(days: 1));
                    } else {
                      _tarih = _payment
                          .sonrakiEkstre(_tarih)
                          .add(const Duration(days: 1));
                    }

                    Transaction tr = Transaction(
                      odemeYontemi: _payment,
                      tutar: taksitTutar,
                      taksitSayisi: _taksit,
                      aciklama:
                          '$_tutar tutarlı harcamanın ${x + 1}. taksiti - $_aciklama',
                      sektor: _sektor,
                      isGelirMi: _income,
                      ertelemeSayisi: _erteleme,
                      timestamp:  _taksitTarih,
                    );

                    Database.sendTransaction(tr);

                    x++;
                  }
                  if (_taksit == 0) {
                  
                    Transaction tr = Transaction(
                        odemeYontemi: _payment,
                        tutar: _tutar,
                        taksitSayisi: _taksit,
                        aciklama: _aciklama,
                        sektor: _sektor,
                        isGelirMi: _income,
                        ertelemeSayisi: _erteleme,
                        timestamp: _tarih);
                    if(hareket!=null){
                      tr.id=hareket.id;
                      Database.updateTransAction(tr);}
                    else{Database.sendTransaction(tr);}
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text("Ekle"),
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
        title: const Text(
          'Hareketler',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // Update with your desired color
      ),
      body: ListView.builder(
        itemCount: Database.transactions.length,
        itemBuilder: (context, index) {
          final hareket = Database.transactions[index];
          return Dismissible(
            key: Key(hareket.aciklama),
            direction: DismissDirection.horizontal,
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // Düzenleme işlemi
                _ekleHareket(hareket: hareket);
                // TODO: Implement düzenleme işlemi
              } else if (direction == DismissDirection.startToEnd) {
                // Silme işlemi
                Database.deleteTransaction(hareket);
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
            child: Card(
              elevation: 2, // Add a shadow effect
              child: ListTile(
                title: Text(
                  hareket.odemeYontemi.name + ' - ' + hareket.odemeYontemi.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                 tarihFormatla(hareket.timestamp) ,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: Text(
                  '${hareket.tutar} TL',
                  style: TextStyle(
                    color: hareket.isGelirMi ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Icon(
                  hareket.isGelirMi ? Icons.arrow_downward : Icons.arrow_upward,
                  color: hareket.isGelirMi ? Colors.green : Colors.red,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() =>  {_ekleHareket(),setState(() {
          
        })},
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue, // Update with your desired color
      ),
    );
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(transaction.aciklama),
        subtitle: Text(transaction.timestamp.toString()),
        trailing: Text('${transaction.tutar} TL'),
        leading: Icon(
          transaction.isGelirMi ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.isGelirMi ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
