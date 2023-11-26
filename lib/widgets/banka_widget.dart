
import 'package:flutter/material.dart';

import '../classes/banka.dart';
import '../classes/odeme_yontemleri.dart';

class BankaWidget extends StatelessWidget {
  final Banka banka;
  const BankaWidget({
    Key? key,
    required this.banka,
  }) : super(key: key);
  
  List<Widget> cardsWidget(List<PaymentMethod> cardlist){
    print("${banka.bankName} bankasına ait ${cardlist.length}}");

    List<Widget> cards = [];
    for (var element in cardlist) {
      cards.add(element.toIcon());
    }

    return cards;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.account_balance),
          title: Text(banka.bankName),
          subtitle: Wrap(children: <Widget> [ Text('Toplam bakiye: ${banka.accountBalance}', ), Text("toplam Borç: ${banka.toplamBorc()}"), Text("toplam kart: ${banka.kredikartlari.length}")],),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(banka.bankName),
                  content: Text('Toplam bakiye: ${banka.accountBalance}'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Kapat'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
