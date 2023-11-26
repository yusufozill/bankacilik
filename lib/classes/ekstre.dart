


import 'odeme_yontemleri.dart';
import 'transaction.dart';

class Ekstre {
  double tutar;
  DateTime odemeTarihi;
  DateTime ekstreTarihi;
  List<Transaction> transactions;
  PaymentMethod card;

  Ekstre({
    required this.tutar,
    required this.odemeTarihi,
    required this.ekstreTarihi,
    required this.transactions,
    required this.card,
  });

  factory Ekstre.fromTransactions({
    required List<Transaction> transactions,
    required DateTime ekstreTarihi,
  }) {
    double tutar = transactions.fold(0, (sum, element) => sum + element.tutar *( element.isGelirMi ? 1 : -1)  );
    PaymentMethod card = transactions.first.odemeYontemi;
    DateTime a = ekstreTarihi.add(const Duration(days: 10));

    print("Ekstre oluşturuldu: Tutar:$tutar, odemeTarihi:${a.day}/${a.month}/${a.year}, ekstreTarihi:${ekstreTarihi.day}/${ekstreTarihi.month}/${ekstreTarihi.year},");

    return Ekstre(
      tutar: tutar,
      odemeTarihi: a,
      ekstreTarihi: ekstreTarihi,
      transactions: transactions,
      card: card,
    );
  }

  // Verilen işlemleri kullanarak Ekstre listesi oluşturan statik bir fonksiyon.
static List<Ekstre> listEkstreFromTransactions(List<Transaction> tr) {
  // İşlemleri zaman damgasına göre sıralar.
  tr.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  // Ekstreler ve geçici işlemler listelerini tanımlar.
  List<Ekstre> ekstreler = [];
  List<Transaction> tempTransactions = [];
  
  // Ödeme yöntemi kartını temsil eden değişkeni tanımlar.
  PaymentMethod? card;

  // Ekstre ekleyen fonksiyonu tanımlar.
  void addEkstre(List<Transaction> a, DateTime ekstreTarihi) {
    if(a.isEmpty) return;
   // String mesaj ="\n${ekstreTarihi.day}/${ekstreTarihi.month}/${ekstreTarihi.year} tarihli ekstre oluşturuluyor: ";
    for (var element in a) {
      //mesaj += "${element.odemeYontemi.bankName.bankName}:${element.tutar}-${element.isGelirMi?"Gelir":"Gider"}, ";
    }
    // İlgili kart için ekstre oluşturuluyor mesajını yazdırır.
   // print(mesaj + " ");


    // Yeni bir Ekstre nesnesi oluşturup listeye ekler.
    ekstreler.add(Ekstre.fromTransactions(
        transactions: a, ekstreTarihi: ekstreTarihi));
    // Geçici işlemleri sıfırlar.
    tempTransactions = [];
  }

  if(tr.isEmpty) return ekstreler;
    card = tr.first.odemeYontemi;
 
  
 DateTime ekstreKesimTarihi = card.ekstreKesimTarihi(
        tr.first.timestamp);
  // İşlemler listesini döngü ile kontrol eder.
  for (var i = 0; i < tr.length; i++) {
    // İlgili işlemi alır.
    Transaction transaction = tr[i];
    if(card.type == DebitCard.cardtype)
    {
      ekstreler.add(Ekstre(tutar: transaction.tutar, odemeTarihi: transaction.timestamp, ekstreTarihi: transaction.timestamp, transactions: [transaction], card: card));
      continue;
    }

    
    
    // Eğer kart null ise, kartı ilgili işlemin ödeme yöntemiyle tanımlar.
    
      // İlgili kart için ekstre oluşturuluyor mesajını yazdırır.

    // İlgili işlemin ekstre kesim tarihini belirler.
    
    
    // Eğer kart değişmişse, diğer işlemleri kontrol etmeden devam eder.
    if (card != transaction.odemeYontemi) continue;

   
   
    // Eğer işlemin tarihi ekstreKesimTarihinden küçük veya eşitse:
    if (transaction.timestamp.millisecondsSinceEpoch <= ekstreKesimTarihi.millisecondsSinceEpoch) {
      
    
      
      // Geçici işlemler listesine işlemi ekler.
      tempTransactions.add(transaction);
      
      // Eğer döngü sona gelinmişse, ekstre oluşturulur.
      if (tr.length == i + 1) {
        addEkstre(tempTransactions, ekstreKesimTarihi);
      }
    } else {
       
        addEkstre(tempTransactions, ekstreKesimTarihi);
        tempTransactions=[];
        if(ekstreler.isNotEmpty)
        {ekstreKesimTarihi = card.sonrakiEkstre(ekstreler.last.ekstreTarihi);}
        {
          ekstreKesimTarihi = card.sonrakiEkstre(transaction.timestamp);
        }
        i--;

      // // İlgili kart için ekstre oluşturuluyor mesajını yazdırır.
      // print(card.bankName.bankName + " ekstre oluşturuluyor ");
      
      // // Geçici işlemler listesine işlemi ekler.
      // tempTransactions.add(transaction);
      
      // // Bir sonraki ayın aynı gününe ekler ve ekstre oluşturur.
      // addEkstre(tempTransactions, ekstreKesimTarihi.add(const Duration(days: 31)));
    }
  }
  
  // Oluşturulan ekstreleri döndürür.
  return ekstreler;
}


  bool isSonOdemeGunuGectimi() {
    return DateTime.now().isAfter(odemeTarihi);
  }

  bool get isEkstreKesildiMi {
    return DateTime.now().isAfter(ekstreTarihi);
  }
}
