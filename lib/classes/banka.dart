
import 'package:flutter/material.dart';

import '../widgets/banka_widget.dart';
import 'odeme_yontemleri.dart';

class Banka {
  final String bankName;
  final double accountBalance;
  final double flexibleAccountBalance;
  List<CreditCard> kredikartlari = [] ;
  List<DebitCard> bankaKartlari  = [] ;
  bool islemGordumu=false;
  Banka({
    required this.bankName,
    required this.accountBalance,
    required this.flexibleAccountBalance,
  });

  factory Banka.random(){
    return Banka(
      bankName: 'Banka ${DateTime.now().microsecondsSinceEpoch}',
      accountBalance: 1000 + DateTime.now().microsecondsSinceEpoch % 1000,
      flexibleAccountBalance: 1000 + DateTime.now().microsecondsSinceEpoch % 1000,
    );
  }
  factory Banka.fromJson(Map<dynamic, dynamic> json) {
    return Banka(
      bankName: json['isim'],
      accountBalance: json['bakiye'],
      flexibleAccountBalance: json['esnekhesap'],

    );
  }
  addCard(PaymentMethod card){
    kredikartlari=[];
    bankaKartlari=[];
    islemGordumu=true;
    if(card.bankName.bankName!=bankName) return;
    if(card is DebitCard){
      bankaKartlari.add(card);
    }
    else if(card is CreditCard){
      
      kredikartlari.add(card);
    }
  }
  addCards(List<PaymentMethod> cards){
    for (var element in cards) {
      addCard(element);
    }
  }


  Widget toWidget(){
    
  //  print("Widget oluşturalacak banka: $bankName, islemBilgisi $islemGordumu, kredi kartı sayısı: ${kredikartlari.length}");
    return BankaWidget(banka: this,);
  }

  double toplamBorc(){
    double toplam=0;
    for (var element in kredikartlari) {
      toplam+=element.toplamBorc();
    }
    return toplam;
  }
}

