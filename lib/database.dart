import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as db;

import 'classes/banka.dart';
import 'classes/odeme_yontemleri.dart';
import 'classes/transaction.dart';

class Database {
  static db.DatabaseReference ref = db.FirebaseDatabase.instance.ref("bankacilik/${FirebaseAuth.instance.currentUser!.uid.toString()}");
  static Map<String, Banka> bankAccounts = {};
  static Map<String, PaymentMethod> paymentMethods = {};
  static List<Transaction> transactions = [];

  static Future<List<Transaction>> getTransactions(DateTime? fromDate, DateTime? toDate) async {
    DateTime startDate = fromDate ?? DateTime.now().subtract(const Duration(days: 365));
    DateTime endDate = toDate ?? DateTime(2024,12,31);
    List<Transaction> transactions = [];
    try {
      db.Query query = ref
          .child('transactions')
          .orderByChild('timestamp')
          .startAt(startDate.millisecondsSinceEpoch)
          .endAt(endDate.millisecondsSinceEpoch);
      db.DataSnapshot snapshot = await query.get();
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        Map<String, dynamic> a = {"id": key};
        a.addAll(value);
        Transaction transaction = Transaction.fromJson(a);
        
        transactions.add(transaction);
        print("${transaction.isGelirMi?"Gelir Ekleniyor":"Gider Ekleniyor"} ${transaction.tutar} ${transaction.odemeYontemi.bankName.bankName}");

      });
    } catch (x) {
      print('Hata');
    }
    return transactions;
  }

  static Future<void> sendTransaction(Transaction transaction) async {
    db.DatabaseReference reference = ref.child('transactions');
    await reference.push().set(transaction.toMap());
    transactions.add(transaction);
    refresh();
  }

  static Future<void> updateTransAction(Transaction transaction) async {
    db.DatabaseReference reference = ref.child('transactions');
    await reference.update({transaction.id: transaction.toMap()});
    transactions.add(transaction);
    refresh();
  }

  static Future<void> deleteTransaction(Transaction transaction) async {
    db.DatabaseReference reference = ref.child('transactions');
    await reference.child(transaction.timestamp.millisecondsSinceEpoch.toString()).remove();
    transactions.remove(transaction);
  }

  static sendBankAccount(String banka, double bakiye, double esnekhesap) async {
    db.DatabaseReference reference = ref.child('bankalar');
    await reference.update({
      banka: {'isim': banka, 'bakiye': bakiye, 'esnekhesap': esnekhesap}
    });
    bankAccounts.addAll({banka: Banka(bankName: banka, accountBalance: bakiye, flexibleAccountBalance: esnekhesap)});
  }

  static void esktreleriHesapla() {
    for (Banka banka in bankAccounts.values) {
      for (var card in Database.paymentMethods.values) {
        banka.addCard(card);
      }
    }
    for (var element in Database.paymentMethods.values) {
      
      element.addTransactions(transactions);
      element.initEkstre();
    }
  }

  static Future<void> refresh() async {
    await init();
  }

  static Future<void> init() async {
    bankAccounts = {};
    paymentMethods = {};
    transactions = [];
    await getBancAccounts();
    await getPaymentMethods();
    transactions = await getTransactions(null, null);
    esktreleriHesapla();
  }

  static getBancAccounts() async {
    List<Banka> bankalar = [];
    bankAccounts = {};
    db.Query query = ref.child('bankalar');
    db.DataSnapshot snapshot = await query.get();
    Map<dynamic, dynamic> values = snapshot.value as Map;
    values.forEach((key, value) {
      Banka banka = Banka.fromJson(value);
      bankalar.add(banka);
      bankAccounts.addAll({banka.bankName: banka});
    });
    return bankalar;
  }

  static sendPaymentMethod(PaymentMethod method) async {
    db.DatabaseReference reference = ref.child('paymentMethods');
    await reference.update({method.cardNumber: method.toMap()});
    await init();
  }

  static getPaymentMethods() async {
    List<PaymentMethod> paymentMethodList = [];
    db.Query query = ref.child('paymentMethods');
    db.DataSnapshot snapshot = await query.get().catchError((e) => {print(e)});
    Map<dynamic, dynamic> values = snapshot.value as Map;
    values.forEach((key, value) {
      PaymentMethod method = PaymentMethod.fromJson(value);
      paymentMethodList.add(method);
      paymentMethods.addAll({method.cardNumber: method});
    });
    return paymentMethodList;
  }
}
