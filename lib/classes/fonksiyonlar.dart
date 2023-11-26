String tarihFormatla(DateTime tarih) {
  final List<String> aylar = [
    '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  String gun = tarih.day.toString();
  String ay = aylar[tarih.month];
  //String yil = tarih.year.toString();

  return '$gun $ay';
}
