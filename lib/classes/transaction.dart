

import '../database.dart';
import 'odeme_yontemleri.dart';

class Transaction {
   String id;
                    PaymentMethod odemeYontemi;
                    double tutar;
                    int taksitSayisi;
                    String aciklama;
                    String sektor;
                    bool isGelirMi;
                    int ertelemeSayisi;
                    DateTime timestamp;
                    
                   

                    Transaction({
                      this.id='',
                      required this.odemeYontemi,
                      required this.tutar,
                      required this.taksitSayisi,
                      required this.aciklama,
                      required this.sektor,
                      required this.isGelirMi,
                      required this.ertelemeSayisi,
                      required this.timestamp,
                    });
        factory Transaction.fromJson(Map<String, dynamic> map) {
          return Transaction(
            id: map['id'],
            odemeYontemi: Database.paymentMethods[map['odemeYontemi']]??PaymentMethod.random(),
            tutar: map['tutar'],
            taksitSayisi: map['taksitSayisi'],
            aciklama: map['aciklama'],
            sektor: map['sektor'],
            isGelirMi: map['isGelirMi'],
            ertelemeSayisi: map['ertelemeSayisi'],
            timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
          );}
         toMap(){
            return {
              "odemeYontemi":odemeYontemi.cardNumber,
              "tutar":tutar,
              "taksitSayisi":taksitSayisi,
              "aciklama":aciklama,
              "sektor":sektor,
              "isGelirMi":isGelirMi,
              "ertelemeSayisi":ertelemeSayisi,
              "timestamp":timestamp.millisecondsSinceEpoch,
            };
         }

  
}
