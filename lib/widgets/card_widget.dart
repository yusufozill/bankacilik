import 'package:flutter/material.dart';

import '../classes/ekstre.dart';
import '../classes/fonksiyonlar.dart';
import '../classes/odeme_yontemleri.dart';

class CreditCardWidget extends StatelessWidget {
  final CreditCard creditCard;

  const CreditCardWidget({Key? key, required this.creditCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    creditCard.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                creditCard.cardNumber,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${creditCard.toplamBorc().toStringAsFixed(2)} / ${creditCard.krediKartiLimiti.toStringAsFixed(0)} ₺',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              Text(
                'Ödeme Tarihi: Her ayın ${creditCard.sonOdemeTarihi}. günü',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              Text(
                'Hesap Özeti borcu: ${creditCard.toplamBorc().toStringAsFixed(0)} ₺',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: [
                  ...creditCard.ekstreler.map((e) => EkstreWidget(ekstre: e))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EkstreWidget extends StatelessWidget {
  final Ekstre ekstre;
  const EkstreWidget({
    Key? key,
    required this.ekstre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          Text(
            ekstre.tutar.toStringAsFixed(2) + " ₺",
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            tarihFormatla(ekstre.odemeTarihi),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class DebitCardWidget extends StatelessWidget {
  final DebitCard debitCard;

  const DebitCardWidget({Key? key, required this.debitCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kart Numarası: ${debitCard.cardNumber}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              Text(
                'Kullanılabilir Bakiye: ${debitCard.availableBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'tip : ${debitCard.type}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'name : ${debitCard.bankName.bankName}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Ek Bakiye: ${debitCard.additionalBalance}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
