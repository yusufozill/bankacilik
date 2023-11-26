
import 'package:flutter/material.dart';

import '../classes/ekstre.dart';
import '../classes/fonksiyonlar.dart';
import '../database.dart';

class TransAcitonDetailScreen extends StatefulWidget {
  const TransAcitonDetailScreen({Key? key}) : super(key: key);

  @override
  State<TransAcitonDetailScreen> createState() =>
      _TransAcitonDetailScreenState();
}

class _TransAcitonDetailScreenState extends State<TransAcitonDetailScreen> {
  double toplamBorc = 0;
  bool isLoading = false;
  List<Ekstre> ekstreler = [];

  @override
  void initState() {
    // TODO: implement initState
    hesapla();

    super.initState();
  }

  Future<void> hesapla() async {
    // 1 Toplam borcu hesaplar
    toplamBorc = 0;
    for (var element in Database.transactions) {
      if (element.isGelirMi) {
        continue;
      }
      toplamBorc += element.tutar;
    }

    ekstreWidgetleriniSirala();
    setState(() {});

    // Ekstreyi hesaplar
  }

  ekstreWidgetleriniSirala() {
    ekstreler = [];

    var x = 0;
    while (x < Database.paymentMethods.length) {
      List<Ekstre> ekstrelerD =
          Database.paymentMethods.values.toList()[x].ekstreler;
      if (ekstrelerD.isEmpty) {
        x++;
        continue;
      }

      late Ekstre ekstre;
      if (ekstrelerD.last.isEkstreKesildiMi) {
        ekstre = ekstrelerD.last;
      } else if (ekstrelerD[ekstrelerD.length - 1].isSonOdemeGunuGectimi()) {
        ekstre = ekstrelerD.last;
      } else {
        ekstre = ekstrelerD[ekstrelerD.length - 1];
      }
      ekstreler.add(ekstre);
      x++;
    }
    ekstreler.sort((a, b) => a.odemeTarihi.compareTo(b.odemeTarihi));

    ekstreler = [];

    Database.paymentMethods.values.forEach((element) {
      if (element.ekstreler.isEmpty) {
        return;
      }
      if (element.ekstreler.last.isSonOdemeGunuGectimi()) {
        return;
      }

      ekstreler.add(element.ekstreler.last);
    });
    ekstreler.sort((a, b) => a.odemeTarihi.compareTo(b.odemeTarihi));
  }

  @override
  Widget build(BuildContext context) {
    var tutamac=0.0;
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Finansal Özet'),
              actions: [
                IconButton(
                  onPressed: () {
                    Database.refresh().then((value) => hesapla());
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Kredi Kartı Ekstreleri',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Toplam borç: $toplamBorc TL",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: ekstreler.length,
                    itemBuilder: (BuildContext context, int index) {
                      tutamac=tutamac+ekstreler[index].tutar;

                      var ekstre = ekstreler[index];
                      
                     Widget booler() {
                        if (index == ekstreler.length - 1) {
                          return SizedBox();
                        }
                        
                        if( ekstre.odemeTarihi.month !=
                            ekstreler[index + 1].odemeTarihi.month){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Divider(height: 2,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${tarihFormatla(ekstreler[index+1].odemeTarihi).split(" ")[1]}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              ),
                            ],
                          );
                            }
                           
if(ekstre.odemeTarihi.day<15 && ekstreler[index + 1].odemeTarihi.day>=15){
  return Divider(height: 40, color: Colors.red,);}
                          return SizedBox();

                      }

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              "${ekstre.tutar} TL",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              tarihFormatla(ekstre.odemeTarihi),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              ekstre.card.name.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Text(
                              ekstre.isEkstreKesildiMi
                                  ? (ekstre.isSonOdemeGunuGectimi()
                                      ? "Ödendi"
                                      : "ödenecek")
                                  : "Kesilecek",
                            ),
                          ),
                          Text("$tutamac ₺",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          booler()
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
  }
}
