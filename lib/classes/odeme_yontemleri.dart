import 'package:flutter/material.dart';
import '../database.dart';
import '../widgets/card_widget.dart';
import 'ekstre.dart';
import 'transaction.dart';
import 'banka.dart';


class PaymentMethod {
  final String cardNumber;
  final Banka bankName;
  final String paraBirimi;
  final String type;
  final String name;
  final String summary;
  List<Ekstre> ekstreler = [];
  List<Transaction> transactions = [];

  PaymentMethod({
    required this.cardNumber,
    required this.bankName,
    required this.name,
    this.summary = "",
    required this.paraBirimi,
    required this.type,
  });

  factory PaymentMethod.random() {
    return PaymentMethod(
      cardNumber: "dd",
      bankName: Banka.random(),
      paraBirimi: "paraBirimi",
      type: "type",
      name: "name",
      summary: "summary",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cardNumber": cardNumber,
      "bankName": bankName.bankName,
      "paraBirimi": paraBirimi,
      "type": type,
      "name": name,
      "summary": summary,
    };
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> method) {
    if (method["type"] == CreditCard.cardtype) {
      return CreditCard.fromMap(method);
    } else if (method["type"] == DebitCard.cardtype) {
      return DebitCard.fromMap(method);
    } else {
      return PaymentMethod(
        cardNumber: method["cardNumber"],
        bankName: Database.bankAccounts[method["bankName"]] ?? Banka.random(),
        paraBirimi: method["paraBirimi"],
        type: method["type"],
        name: "Axess",
        summary: "ilk kart",
      );
    }
  }

  Widget toWidget() {
    return const Text("error");
  }

  Widget toIcon() {
    return const Text("error");
  }

  DateTime sonOdemeTarihiHesapla(DateTime time) {
    return DateTime(time.year, time.month, 30, 23, 59, 59, 59);
  }

  DateTime ekstreKesimTarihi(DateTime time) {
      print("HATAAA");
    return DateTime(time.year, time.month, 30, 23, 59, 59, 0);
  }

  void addTransactions(List<Transaction> transactionsList) {
    for (var element in transactionsList) {
      if (element.odemeYontemi.cardNumber == cardNumber) {
        transactions.add(element);
      }
    }
  }

  void initEkstre() {
    ekstreler = Ekstre.listEkstreFromTransactions(transactions);
  }
  DateTime sonrakiEkstre(DateTime time){
    late DateTime _time;
    if(time.month==12){
      _time = DateTime(time.year+1, 1, 1);
    }
    else{
      _time = DateTime(time.year, time.month+1, 1);
    }

   return ekstreKesimTarihi(_time); 
  }
}

class CreditCard extends PaymentMethod {
  final int sonOdemeTarihi;
  final int hesapKesimTarihi;
  final double krediKartiLimiti;
  final double eksiParaBakiyesi;
  static const String cardtype = "creditCard";

  CreditCard({
    required this.sonOdemeTarihi,
    required this.krediKartiLimiti,
    required this.eksiParaBakiyesi,
    required this.hesapKesimTarihi,
    required String cardNumber,
    required Banka bankName,
    required String paraBirimi,
    required String type,
    required String name,
    String? summary,
  }) : super(
          cardNumber: cardNumber,
          bankName: bankName,
          paraBirimi: paraBirimi,
          type: type,
          name: name,
          summary: summary ?? "",
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      "cardNumber": cardNumber,
      "bankName": bankName.bankName,
      "paraBirimi": paraBirimi,
      "type": cardtype,
      "sonOdemeTarihi": sonOdemeTarihi,
      "hesapKesimTarihi": hesapKesimTarihi,
      "krediKartiLimiti": krediKartiLimiti,
      "eksiParaBakiyesi": eksiParaBakiyesi,
      "name": name,
      "summary": summary,
    };
  }

  factory CreditCard.fromMap(Map<String, dynamic> method) {
    return CreditCard(
      cardNumber: method["cardNumber"],
      bankName: Database.bankAccounts[method["bankName"]] ?? Banka.random(),
      paraBirimi: method["paraBirimi"],
      type: method["type"],
      hesapKesimTarihi: method["hesapKesimTarihi"],
      sonOdemeTarihi: method["sonOdemeTarihi"],
      krediKartiLimiti: method["krediKartiLimiti"],
      eksiParaBakiyesi: method["eksiParaBakiyesi"],
      name: method["name"],
      summary: method["summary"],
    );
  }

  @override
  Widget toWidget() {
    return CreditCardWidget(creditCard: this);
  }

  @override
  Widget toIcon() {
    return Text(cardNumber);
  }

  @override
  DateTime sonOdemeTarihiHesapla(DateTime time) {
    return DateTime(time.year,time. month, sonOdemeTarihi);
  }

  @override
  DateTime ekstreKesimTarihi(DateTime time) {
    return DateTime(time.year,time. month, hesapKesimTarihi, 23, 59, 59);
  }

  @override
  void addTransactions(List<Transaction> transactionsList) {
    for (var element in transactionsList) {
      if (element.odemeYontemi.cardNumber == cardNumber) {
        transactions.add(element);
      }
    }
  }

  double toplamBorc() {
    double toplam = 0;
    for (var element in ekstreler) {
      if (!element.isSonOdemeGunuGectimi()) {
        toplam += element.tutar;
      }
    }
    return toplam;
  }
}

class DebitCard extends PaymentMethod {
  final double availableBalance;
  final double additionalBalance;
  static const String cardtype = "DebitCard";

  DebitCard({
    required this.additionalBalance,
    required this.availableBalance,
    required String cardNumber,
    required Banka bankName,
    required String paraBirimi,
    required String type,
    required String name,
    String? summary,
  }) : super(
          cardNumber: cardNumber,
          bankName: bankName,
          paraBirimi: paraBirimi,
          type: type,
          name: name,
          summary: summary ?? "",
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      "cardNumber": cardNumber,
      "bankName": bankName.bankName,
      "paraBirimi": paraBirimi,
      "type": cardtype,
      "availableBalance": availableBalance,
      "additionalBalance": additionalBalance,
      "name": name,
      "summary": summary,
    };
  }

  factory DebitCard.fromMap(Map<String, dynamic> method) {
    return DebitCard(
      cardNumber: method["cardNumber"],
      bankName: Database.bankAccounts[method["bankName"]] ?? Banka.random(),
      paraBirimi: method["paraBirimi"],
      type: method["type"],
      availableBalance: method["availableBalance"],
      additionalBalance: method["additionalBalance"],
      name: method["name"],
      summary: method["summary"],
    );
  }

  @override
  Widget toWidget() {
    return DebitCardWidget(debitCard: this);
  }

  @override
  Widget toIcon() {
    return Text(cardNumber);
  }

  @override
  DateTime sonOdemeTarihiHesapla(DateTime time) {
    return DateTime(time.year, time.month, 30, 23, 59, 59, 59);
  }
}
