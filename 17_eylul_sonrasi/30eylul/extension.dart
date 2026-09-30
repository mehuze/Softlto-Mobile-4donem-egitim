extension oyunSayiUzantisi on int {
  String get toXpFormat {
    if (this < 1000) return "$this XP";
    return "${(this / 1000).toStringAsFixed(1)}K Xp";
  }
  /*Uzantı Tanımı (extension oyunSayiUzantisi on int): Dart dilinde hazır 
  veri türlerine (bu örnekte int yani tam sayılara) kendi özel metotlarımızı veya getter'larımızı eklememizi sağlar.
   Mevcut sınıfı değiştirmeden dışarıdan yeni yetenekler kazandırır.*/
}

extension MetinSansurUzantisi on String {
  String get temizOyuncuAdi {
    if (this.toLowerCase().contains("hile")) {
      return "[YASAKLI_OYUNCU]";
    }
    return "$this";
  }
}

void main() {
  print("Extension metotları(tip genişletmeleri)");
  // int test ediyoruz
  final int kazanilanXp1 = 450;
  final int kazanilanXp2 = 12850;

  print("Görev 1 Ödülü    : ${kazanilanXp1.toXpFormat}");
  print("Boss Savaşı     : ${kazanilanXp2.toXpFormat}");

  final String oyuncu1 = "EjderKatili";
  final String oyuncu2 = "HileciAlaaddin";

  print("Kayıt 1 ${oyuncu1.temizOyuncuAdi}");
  print("Kayıt 2 ${oyuncu2.temizOyuncuAdi}");
}
