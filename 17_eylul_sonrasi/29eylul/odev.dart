/*enum, kısaca "seçenekler menüsü" gibidir. Bir cihazın tipi rastgele bir şey olamaz;
 ya bu listedeki sensor, gateway, edgeServer ya da router olmak zorundadır.
 Programın ilerleyen yerlerinde yanlış bir kelime yazıp hata yapmamızı engeller, sınırları belirler.*/

enum CihazTipi { sensor, gateway, edgeServer, router }

/*Burada ne yaptık?

Özellikler (Fields): Her cihazın bir seri numarası, adı, tipi, CPU yüzdesi vb. olacağını tanımladık.

Set<String> acikPortlar: Portları tutmak için neden Set kullandık?
 Çünkü port numaralarının listede yanlışlıkla iki kez tekrar etmesini istemeyiz, Set yapısı benzersiz (tekil) veriler tutar.

Getter (guvenlikAcigiVarMi):ödevimdeki guvenlik açığı kontrolü kısmı
 "SSL sertifikası geçerli değilse (!sslSertifikasiGecerliMi) VEYA açık portlar içinde '23/TELNET' varsa" cihazda güvenlik açığı var demektir
  ve bu getter bize otomatik olarak true ya da false verir*/

class IoTCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  final Set<String> acikPortlar;
  final bool sslSertifikasiGecerliMi;

  // Cihazın aktif olup olmadığını belirleyen alan
  final bool aktifMi;

  // Yapıcı metot (Constructor)
  IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
    this.aktifMi = true, // DİKKAT: Burada 'required' YOK!//: Cihazı oluştururken bu alanı isteğe bağlı hale getirdik ve varsayılan değerini true yaptık.
    // Yani biz özellikle kapalı olduğunu belirtmediğimiz sürece, yeni oluşturulan her cihaz otomatik olarak açık (aktif) kabul edilecek.
    /*Neden yaptık?
Çünkü son adımda, listemizdeki cihazları tararken bunlardan birini kapalı (aktifMi: false) yapıp,
 özel hata yönetimimiz (try-catch ve CihazErisilemezException) ile yakalamasını test edebileceğiz.*/
  });

  // Güvenlik Açığı Kontrolü (Getter)
  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");
}

// Programın koştğu yer
void main() {
  //en az 6 farklı IoT cihazı ürettik.bunları bir liste (List<IoTCihaz>) içinde tuttuk.
  //Her bir cihazın özellikleri (CPU'su, portları, SSL durumu vb.) birbirinden farklı olmalı ki ilerleyen adımlarda filtreleme yapabilelim.
  // Köşeli parantezler [...] kullanarak bir Liste (List) oluşturdum ve içine az önce yazdığım sınıftan (IoTCihaz) 6 tane farklı cihaz nesnesi yerleştirdim.
  List<IoTCihaz> agCihazlari = [
    IoTCihaz(
      seriNo: "SNS-101",
      cihazAdi: "Sıcaklık Sensörü",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 40.0,
      bellekMb: 128,
      acikPortlar: {"80/HTTP"},
      sslSertifikasiGecerliMi: true,
    ),

    IoTCihaz(
      seriNo: "GTW-202",
      cihazAdi: "Ana Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 92.0, // Yüksek CPU
      bellekMb: 1024,
      acikPortlar: {
        "23/TELNET",
        "443/HTTPS",
      }, // Telnet açık (Güvenlik açığı yaratacak)
      sslSertifikasiGecerliMi: false, // SSL geçersiz (Güvenlik açığı yaratacak)
    ),
    IoTCihaz(
      seriNo: "EDG-303",
      cihazAdi: "Kenar Sunucu",
      tip: CihazTipi.edgeServer,
      cpuYukYuzdesi: 55.0,
      bellekMb: 2048,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "RTR-404",
      cihazAdi: "Çekirdek Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 25.0,
      bellekMb: 512,
      acikPortlar: {"22/SSH"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "SNS-102",
      cihazAdi: "Basınç Sensörü",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 88.0, // Bu da yüksek CPU'ya sahip
      bellekMb: 256,
      acikPortlar: {"80/HTTP"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "GTW-205",
      cihazAdi: "Yedek Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 15.0,
      bellekMb: 512,
      acikPortlar: {"80/HTTP"},
      sslSertifikasiGecerliMi: true,
      aktifMi: false,
    ),
  ];

  print("Toplam cihaz sayısı: ${agCihazlari.length}");

  // 4. Adım: .where() ile riskli cihazları süzüyoruz
  /*oluşturduğumuz 6 cihazlık listenin içinden filtreleme yapıp sadece riskli olanları ayıklayacağız. 
  Kuralımız neydi?: Güvenlik açığı varsa VEYA CPU kullanımı %85'ten büyükse cihaz riskli kabul ediliyordu*/
  var riskliCihazlar = agCihazlari
      .where((cihaz) => cihaz.guvenlikAcigiVarMi || cihaz.cpuYukYuzdesi > 85)
      .toList();

  print("\n--- 4. RİSKLİ CİHAZLAR ---");
  for (var cihaz in riskliCihazlar) {
    print(" Riskli Cihaz: ${cihaz.cihazAdi} (CPU: ${cihaz.cpuYukYuzdesi}%)");
  }

  //  .fold() ile toplam belleği hesaplıyoruz
  int toplamBellek = agCihazlari.fold(
    0, //fold(0, ...): Toplama işlemine sıfırdan (0) başla diyoruz (boş bir sepet gibi düşünelim)
    (toplam, cihaz) => toplam + cihaz.bellekMb,
  ); //Döngü her bir cihazın üzerinden geçerken sepetimizdeki değere o cihazın bellek miktarını ekliyor ve en sonunda tüm ağın toplam bellek yükünü bulmuş oluyor.

  print("\n--- 5. TOPLAM BELLEK ---");
  print("Ağdaki Toplam Bellek Tüketimi: $toplamBellek MB");

  // 6. Adım Testi: Record kullanımı
  print("\n--- 6. SERİ NUMARASINA GÖRE SORGULAMA (Record) ---");
  try {
    var sonucRecord = cihazBilgisiSorgula(agCihazlari, "GTW-202");

    // Record öğelerine .$1, .$2, .$3 şeklinde sırayla erişiyoruz
    print(
      "Sorgulanan Cihaz -> Adı: ${sonucRecord.$1}, Tipi: ${sonucRecord.$2}, Alarm Durumu: ${sonucRecord.$3}",
    );
  } catch (e) {
    print("Hata: $e");
  }

  //  Switch Expression kullanımı
  print("\n--- 7. İZOLASYON BÖLGELERİ (Switch Expression) ---");
  for (var cihaz in agCihazlari) {
    String bolgeKodu = izolasyonBolgesiGetir(cihaz.tip);
    print("${cihaz.cihazAdi} (${cihaz.tip.name}) -> Atanan Bölge: $bolgeKodu");
  }

  //  Try-Catch ile erişilebilirlik kontrolü
  print("\n--- 8. ERİŞİLEBİLİRLİK KONTROLÜ (Try-Catch) ---");
  for (var cihaz in agCihazlari) {
    try {
      print("Bağlanılıyor: ${cihaz.cihazAdi}...");

      // Eğer cihaz aktif değilse (kapalıysa), özel hatamızı fırlatıyoruz!
      if (!cihaz.aktifMi) {
        throw CihazErisilemezException(
          "KRİTİK HATA: ${cihaz.cihazAdi} çevrimdışı ve erişilemiyor!",
        );
      }

      print("-> Başarıyla bağlanıldı.");
    } on CihazErisilemezException catch (e) {
      // Özel hatamız yakalandığında burası çalışır
      print(" Yakalanan Özel Hata: $e");
    } catch (e) {
      // Beklenmeyen başka bir hata olursa
      print(" Genel Hata: $e");
    }
  }
}

/*Ödev benden şunu istiyordu: Bir cihazın seri numarasını verdiğimizde, bize o cihaz hakkında 
tek seferde 3 farklı bilgi (Cihaz adı, Cihaz tipi ve Alarm durumu) döndüren bir metot yazmamı istiyor.*/
//Record (Kayıt) özelliği tam olarak bu işe yarar; birden fazla farklı türdeki veriyi tek bir paket halinde dışarı fırlatmamızı sağlar.
// Seri numarasına göre cihaz bulan ve Dart 3 Record döndüren metot
(String cihazAdi, CihazTipi tip, bool alarmDurumu) cihazBilgisiSorgula(
  List<IoTCihaz> cihazlar,
  String arananSeriNo,
) {
  // Cihazı arıyoruz, bulamazsak hata fırlatıyoruz
  final cihazkan = cihazlar.firstWhere(
    (c) => c.seriNo == arananSeriNo,
    orElse: () => throw Exception("Seri numarası bulunamadı: $arananSeriNo"),
  );

  // Alarm durumu: Güvenlik açığı varsa veya CPU %85'ten büyükse true olur
  bool alarm = cihazkan.guvenlikAcigiVarMi || cihazkan.cpuYukYuzdesi > 85;

  // Dart 3 Record formatında çoklu veriyi paketleyip döndürüyoruz
  return (cihazkan.cihazAdi, cihazkan.tip, alarm);
}

// Cihaz tipine göre izolasyon bölgesi döndüren Switch Expression
/*Ödev benden, cihazın türüne (tip) bakarak ona ait bir güvenlik izolasyon bölgesi kodu (ZONE-S, ZONE-G vb.) 
döndüren modern bir Switch Expression yazmamı istiyordu.*/
String izolasyonBolgesiGetir(CihazTipi tip) {
  return switch (tip) {
    CihazTipi.sensor => "ZONE-S",
    CihazTipi.gateway => "ZONE-G",
    CihazTipi.edgeServer => "ZONE-E",
    CihazTipi.router => "ZONE-R",
  };
}

//  Özel Exception Sınıfı
class CihazErisilemezException implements Exception {
  //Dart diline, "Ben normal bir sınıf değilim, ben özel bir hata (exception) sınıfıyım" diyoruz

  final String mesaj; //Bu hatayı tetiklediğimizde içine kendi yazacağımız özel hata mesajını (örneğin "Cihaz yanıt vermiyor!") dışarıdan içeri aktarmamızı sağlar.

  CihazErisilemezException(this.mesaj);

  @override
  String toString() => mesaj; //Dart'ta bir hata fırlatıldığında ekrana karmaşık sistem yazıları yazmak yerine,
  //bizim verdiğimiz o anlaşılır mesaj metninin yazdırılmasını sağlar.
}
/*Proje Çalıştırıldığında Gördüğüm Adımlar ve Çıktılar:
Toplam Cihaz Sayısı:

Ağ üzerinde tanımladığımız toplam 6 adet IoT cihazının sisteme başarıyla yüklendiğini gördüm.


Riskli Cihazlar Filtrelemesi (.where):

Sınıf içerisindeki getter mantığıyla (guvenlikAcigiVarMi || cpuYukYuzdesi > 85), CPU yükü %85'i geçen Ana Gateway (%92)
 ve Basınç Sensörü (%88) riskli cihazlar olarak filtrelendi ve ekrana uyarı olarak yazdırıldı.


Toplam Bellek Hesaplaması (.fold):

Ağdaki bütün cihazların RAM (bellekMb) değerleri sıfırdan başlatılarak toplandı ve toplam ağ bellek tüketimi 4480 MB olarak hesaplandı.


Seri Numarasına Göre Sorgulama (Dart 3 Records):

cihazBilgisiSorgula fonksiyonu ile belirli bir seri numarası (GTW-202) aratıldı ve 
tek seferde birden fazla veri (Cihaz Adı, Tipi ve Alarm Durumu: true) paketlenip ekrana yazdırıldı.



İzolasyon Bölgeleri Ataması (Switch Expressions):

Dart 3'ün modern switch yapısı sayesinde her cihaz türü (sensor, gateway, edgeServer, router) kendi 
ilgili güvenlik bölgesine (ZONE-S, ZONE-G, ZONE-E, ZONE-R) hatasız bir şekilde eşleştirilip listelendi.



Erişilebilirlik ve Hata Yönetimi (try-catch & Custom Exception):

Döngü içerisindeki cihazlara sırayla bağlanılırken, eğer cihaz aktif değilse (aktifMi: false) sistem otomatik olarak yazdığımız özel
 CihazErisilemezException hatasını fırlattı. try-catch bloğu bu hatayı havada yakalayarak programın çökmesini engelledi ve güvenli bir şekilde ,
  Yakalanan Özel Hata mesajını ekrana bastı.*/

/*Toplam cihaz sayısı: 6

--- 4. RİSKLİ CİHAZLAR ---
 Riskli Cihaz: Ana Gateway (CPU: 92.0%)
 Riskli Cihaz: Basınç Sensörü (CPU: 88.0%)

--- 5. TOPLAM BELLEK ---
Ağdaki Toplam Bellek Tüketimi: 4480 MB

--- 6. SERİ NUMARASINA GÖRE SORGULAMA (Record) ---
Sorgulanan Cihaz -> Adı: Ana Gateway, Tipi: CihazTipi.gateway, Alarm Durumu: true

--- 7. İZOLASYON BÖLGELERİ (Switch Expression) ---
Sıcaklık Sensörü (sensor) -> Atanan Bölge: ZONE-S
Ana Gateway (gateway) -> Atanan Bölge: ZONE-G
Kenar Sunucu (edgeServer) -> Atanan Bölge: ZONE-E
Çekirdek Router (router) -> Atanan Bölge: ZONE-R
Basınç Sensörü (sensor) -> Atanan Bölge: ZONE-S
Yedek Gateway (gateway) -> Atanan Bölge: ZONE-G

--- 8. ERİŞİLEBİLİRLİK KONTROLÜ (Try-Catch) ---
Bağlanılıyor: Sıcaklık Sensörü...
-> Başarıyla bağlanıldı.
Bağlanılıyor: Ana Gateway...
-> Başarıyla bağlanıldı.
Bağlanılıyor: Kenar Sunucu...
-> Başarıyla bağlanıldı.
Bağlanılıyor: Çekirdek Router...
-> Başarıyla bağlanıldı.
Bağlanılıyor: Basınç Sensörü...
-> Başarıyla bağlanıldı.
Bağlanılıyor: Yedek Gateway...
Yakalanan Özel Hata: KRİTİK HATA: Yedek Gateway çevrimdışı ve erişilemiyor!*/
