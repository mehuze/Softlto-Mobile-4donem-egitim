/* -------------------------------------------------------------------------- */
/* 1. ENUMLAR (Derleme Zamanı Güvenliği ve Sabit Seçenekler)                 */
/* -------------------------------------------------------------------------- */

/* Klinik bünyesinde sunulan hizmet kategorilerini sabit seçenekler olarak tanımlar. */
enum HizmetKategorisi {
  /* Cilt yenileme hizmet kategorisi. */
  ciltYenileme,
  /* Medikal estetik hizmet kategorisi. */
  medikalEstetik,
  /* Lazer epilasyon hizmet kategorisi. */
  lazerEpilasyon,
  /* Lipo (Liposuction/Bölgesel incelme) hizmet kategorisi. */
  Lipo,
}

/* Bir seansın o anki durum aşamalarını takip etmeyi sağlar. */
enum SeansDurumu {
  /* Seansın henüz başlamadığını, beklemede olduğunu belirtir. */
  bekliyor,
  /* Danışanın şu an odada işlemde olduğunu belirtir. */
  odadaIslemde,
  /* Seansın başarıyla tamamlandığını belirtir. */
  tamamlandi,
  /* Seansın iptal edildiğini belirtir. */
  iptalEdildi,
}

/* Ödeme işlemlerinde geçerli olan yöntem alternatiflerini listeler. */
enum OdemeYontemi {
  /* Kredi kartı ile yapılan ödeme yöntemi. */
  krediKarti,
  /* Havale veya EFT ile yapılan ödeme yöntemi. */
  havaleEft,
  /* Nakit para ile yapılan ödeme yöntemi. */
  nakit,
  /* Kliniğin paket kredisinden düşülen ödeme yöntemi. */
  klinikPaketKredisi,
}

/* -------------------------------------------------------------------------- */
/* 2. DANIŞAN (MÜŞTERİ) MODELİ SINIFI                                        */
/* -------------------------------------------------------------------------- */

/* Kliniğe gelen danışanların verilerini tutmak için oluşturulan ana veri modelidir. */
class Danisan {
  /* Danışana ait benzersiz kimlik numarasını tutar ve sonradan değiştirilemez. */
  final String id;

  /* Danışanın ad ve soyad bilgisini tutar. */
  final String adSoyad;

  /* Danışanın iletişim için telefon numarasını saklar. */
  final String telefon;

  /* Danışanın VIP üye olup olmadığını belirten boolean değerdir. */
  final bool vipUyeMi;

  /* Danışanın varsa alerjilerini liste olarak tutar. */
  final List<String> alerjiler;

  /* Danışana özel opsiyonel cilt notudur; null olabilir. */
  final String? ozelCiltNotu;

  /* Danışan nesnesi oluşturulurken çağrılan sabit constructor metottur. */
  const Danisan({
    /* Danışanın ID bilgisini zorunlu olarak alır. */
    required this.id,
    /* Danışanın ad soyad bilgisini zorunlu olarak alır. */
    required this.adSoyad,
    /* Danışanın telefon numarasını zorunlu olarak alır. */
    required this.telefon,
    /* VIP üyelik durumunu alır; belirtilmezse varsayılan olarak false atar. */
    this.vipUyeMi = false,
    /* Alerji listesini alır; belirtilmezse boş liste atar. */
    this.alerjiler = const [],
    /* Opsiyonel özel cilt notunu alır. */
    this.ozelCiltNotu,
  });

  /* Danışanın hassas ciltli olup olmadığını alerji listesine bakarak hesaplayan getter. */
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  /* Danışana ait önemli bilgileri tek satırda özetleyen getter metot. */
  String get bilgiOzeti {
    /* Alerji listesi boşsa mesaj yazar, doluysa birleştirip metne çevirir. */
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";

    /* Özel cilt notu yoksa varsayılan metin atar, varsa notu kullanır. */
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";

    /* VIP üyelik durumuna göre rozet metnini belirler. */
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";

    /* Tüm bilgileri şık bir formatta birleştirip döndürür. */
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

/* -------------------------------------------------------------------------- */
/* 3. SEANS (RANDEVU) MODELİ SINIFI                                          */
/* -------------------------------------------------------------------------- */

/* Kliniğe gelen randevuların ve seansların detaylarını tutan veri modelidir. */
class SeansKaydi {
  /* Seansa ait benzersiz sistem kodunu tutar. */
  final String seansKodu;

  /* Bu seansın hangi danışana ait olduğunu belirten Danisan nesnesidir. */
  final Danisan danisan;

  /* Seansın hangi hizmet kategorisine ait olduğunu saklar. */
  final HizmetKategorisi kategori;

  /* Yapılacak spesifik işlemin adını tutar. */
  final String islemAdi;

  /* İşlemin birim fiyat bilgisidir. */
  final double birimFiyat;

  /* Toplam seans sayısını belirtir; varsayılanı 1'dir. */
  final int seansSayisi;

  /* Uygulanan indirim oranını yüzde cinsinden tutar. */
  final double indirimOrani;

  /* Seansla ilgilenecek sorumlu uzmanın adını tutar; null olabilir. */
  final String? sorumluUzman;

  /* Seansın o anki durumunu takip eder. */
  SeansDurumu durum;

  /* Ödemenin hangi yöntemle yapıldığını tutar. */
  OdemeYontemi? odemeTipi;

  /* Seans kaydı nesnesi oluşturulurken çağrılan constructor metottur. */
  SeansKaydi({
    /* Seans kodunu zorunlu olarak alır. */
    required this.seansKodu,
    /* Danışan nesnesini zorunlu olarak alır. */
    required this.danisan,
    /* Hizmet kategorisini zorunlu olarak alır. */
    required this.kategori,
    /* İşlem adını zorunlu olarak alır. */
    required this.islemAdi,
    /* Birim fiyatı zorunlu olarak alır. */
    required this.birimFiyat,
    /* Seans sayısını alır; belirtilmezse 1'dir. */
    this.seansSayisi = 1,
    /* İndirim oranını alır; belirtilmezse 0.0'dır. */
    this.indirimOrani = 0.0,
    /* Sorumlu uzman adını alır; opsiyoneldir. */
    this.sorumluUzman,
    /* Seans durumunu alır; belirtilmezse 'bekliyor' olarak atanır. */
    this.durum = SeansDurumu.bekliyor,
    /* Ödeme tipini alır; başlangıçta boştur. */
    this.odemeTipi,
  });

  /* Brüt toplam tutarı hesaplayan getter. */
  double get brutTutar => birimFiyat * seansSayisi;

  /* Toplam indirim miktarını (VIP bonusu dahil) hesaplayan getter. */
  double get indirimTutari {
    double toplamOran = indirimOrani;

    /* Danışan VIP üyeyse indirime %10 daha ekler. */
    if (danisan.vipUyeMi) {
      toplamOran += 10.0;
    }

    /* TL cinsinden indirim tutarını hesaplayıp döndürür. */
    return brutTutar * (toplamOran / 100.0);
  }

  /* Net ödenecek tutarı hesaplayan getter. */
  double get netTutar => brutTutar - indirimTutari;
}

/* -------------------------------------------------------------------------- */
/* 4. YÖNETİM SERVİSİ (KLİNİK YÖNETİCİSİ)                                    */
/* -------------------------------------------------------------------------- */

/* Klinik şubesini, randevuları ve danışman kayıtlarını yöneten ana sınıftır. */
class KlinikYoneticisi {
  /* Kliniğin şube adını tutar. */
  final String subeAdi;

  /* Tüm seans kayıtlarını saklayan özel listedir. */
  final List<SeansKaydi> _seanslar = [];

  /* Danışanları ID numaralarıyla eşleştirip tutan sözlüktür. */
  final Map<String, Danisan> _danisanRehberi = {};

  /* Yönetici sınıfı ilk oluşturulduğunda şube adını zorunlu kılar. */
  KlinikYoneticisi({required this.subeAdi});

  /* Yeni bir danışanı sisteme kaydeden fonksiyondur. */
  void danisanKaydet(Danisan danisan) {
    /* Danışanı ID anahtarı ile rehber sözlüğüne ekler. */
    _danisanRehberi[danisan.id] = danisan;

    /* Kayıt başarılı mesajını konsola yazdırır. */
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  /* Yeni bir randevu oluşturan fonksiyondur. */
  void randevuOlustur(SeansKaydi seans) {
    /* Seans kaydını ana listeye ekler. */
    _seanslar.add(seans);

    /* Randevu kayıt bilgisini konsola yazdırır. */
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad} -> ${seans.islemAdi}",
    );
  }

  /* Belirtilen seansın durumunu tamamlandı yapıp ödemesini alan fonksiyondur. */
  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    /* Tüm seanslar içinde aranan kodu arar. */
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        /* Seans durumunu tamamlandı olarak günceller. */
        seans.durum = SeansDurumu.tamamlandi;
        /* Ödeme tipini kaydeder. */
        seans.odemeTipi = odeme;

        /* Tahsilat bilgisini ekrana yazdırır. */
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
        return;
      }
    }
    /* Seans bulunamazsa hata mesajı yazdırır. */
    print("Hata [$seansKodu] kodlu seans bulunamadı");
  }

  /* Belirtilen seansın durumunu iptal eden fonksiyondur. */
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    /* Seans listesinde ilgili kodu arar. */
    for (var seans in _seanslar) {
      if (seans.seansKodu == seansKodu) {
        /* Seans durumunu iptal edildi olarak günceller. */
        seans.durum = SeansDurumu.iptalEdildi;

        /* İptal nedenini konsola yazdırır. */
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        return;
      }
    }
  }

  /* Tamamlanan seansların net tutarlarını toplayarak gerçek ciroyu hesaplayan getter. */
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi)
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  /* Henüz tamamlanmamış seansların tutarlarını toplayarak potansiyel alacağı hesaplayan getter. */
  double get beklenenPotansiyelCiro => _seanslar
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor ||
            s.durum == SeansDurumu.odadaIslemde,
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar);

  /* Kategori bazlı seans dağılımını hesaplayıp sözlük olarak döndüren metot. */
  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {};

    /* Kategorileri başlangıçta sıfırlar. */
    for (var kat in HizmetKategorisi.values) {
      dagilim[kat] = 0;
    }

    /* Seanslara göre sayaçları artırır. */
    for (var s in _seanslar) {
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1;
    }
    return dagilim;
  }

  /* Görevli uzman kadrosunu tekilleştirerek döndüren metot. */
  Set<String> gorevliUzmanKadrosu() {
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  /* Uzman atanmamış seansları liste olarak döndüren metot. */
  List<SeansKaydi> uzmansizSeanslariGetir() {
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  /* Gün sonu raporunu tablo formatında konsola yazdıran ana metottur. */
  void gunSonuRaporuYazdir() {
    /* Rapor başlığı bilgisini konsola yazdırır. */
    print("Günlük Seans ve İşlem Çizelgesi");
    /* Tablo üstü ayırıcı çizgiyi yazdırır. */
    print("---------------------------------------");

    /* Tablo sütun başlıklarını belirli boşluk bırakma (padRight) formatıyla yazdırır. */
    print(
      /* Sütun başlığı olarak 'Kod' ifadesini ve sağında boşluk bırakmayı tanımlar. */
      "${'Kod'.padRight(10)} | "
      /* Sütun başlığı olarak 'Danışan' ifadesini yazar. */
      "${'Danışan'.padRight(16)} | "
      /* Sütun başlığı olarak 'İşlem' adını yazar. */
      "${'İşlem'.padRight(20)} | "
      /* Sütun başlığı olarak 'Uzman' adını yazar. */
      "${'Uzman'.padRight(18)} | "
      /* Sütun başlığı olarak 'Tutar' bilgisini yazar. */
      "${'Tutar'.padRight(10)} | "
      /* Sütun başlığı olarak 'Durum' bilgisini yazar. */
      "${'Durum'} | ",
    );
    /* Başlık altı ayırıcı çizgiyi yazdırır. */
    print("---------------------------------------");

    /* Tüm seanslar üzerinde dönerek her biri için tablo satırı oluşturur. */
    for (var s in _seanslar) {
      /* Seansın sorumlu uzmanı yoksa 'Nöbetçi Bekliyor' metnini atar. */
      final String uzman = s.sorumluUzman ?? "Nöbetçi Bekliyor";

      /* Seans durumuna karşılık gelen Türkçe rozet metnini switch yapısıyla belirler. */
      final String durumRozet = switch (s.durum) {
        /* Tamamlandı durumu için rozet metni. */
        SeansDurumu.tamamlandi => "Tamamlandı",
        /* İşlemde durumu için rozet metni. */
        SeansDurumu.odadaIslemde => "İşlemde",
        /* Bekliyor durumu için rozet metni. */
        SeansDurumu.bekliyor => "Bekliyor",
        /* İptal edildi durumu için rozet metni. */
        SeansDurumu.iptalEdildi => "İptal",
      };

      /* Her bir seansın detaylarını biçimlendirerek yazdırır. */
      print(
        /* Seans kodunu ve hizalama boşluğunu ekler. */
        "${s.seansKodu.padRight(10)} | "
        /* Danışan ad soyad bilgisini ve hizalamasını ekler. */
        "${s.danisan.adSoyad.padRight(16)} | "
        /* İşlem adını ve hizalamasını ekler. */
        "${s.islemAdi.padRight(20)} | "
        /* Uzman adını ve hizalamasını ekler. */
        "${uzman.padRight(18)} | "
        /* Net tutarı iki ondalık basamakla biçimlendirip ekler. */
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        /* Durum rozet metnini ekler. */
        "$durumRozet",
      );
    }

    /* Tablo bitişi ayırıcı çizgiyi yazdırır. */
    print("---------------------------------------");
    /* Finansal özet başlığını yazdırır. */
    print("Finansal Özet:");
    /* Tahsil edilen gerçek ciro miktarını ekrana yazar. */
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    /* Bekleyen potansiyel alacak miktarını ekrana yazar. */
    print(
      " * Bekleyen Potansiyel Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    /* Toplam randevu/seans sayısını ekrana yazar. */
    print(" * Toplam Seans : ${_seanslar.length} Randevu");

    /* Bölüm ayırıcı çizgiyi yazdırır. */
    print("---------------------------------------");
    /* Aktif uzmanlar başlığını yazdırır. */
    print("Aktif Uzmanlar");
    /* Görevli uzman kadrosunu fonksiyondan alır. */
    final uzmanlar = gorevliUzmanKadrosu();
    /* Uzman listesi boşsa uyarı mesajı yazdırır. */
    if (uzmanlar.isEmpty) {
      print("Kayıtlı Uzman Bulunamadı");
    } else {
      /* Uzman isimlerini virgülle birleştirip yazdırır. */
      print(" ${uzmanlar.join(', ')}");
    }

    /* Uzmanı atanmamış seansları listeden alır. */
    final uzmansizlar = uzmansizSeanslariGetir();
    /* Uzmansız seans varsa uyarı mesajı ve detaylarını listeler. */
    if (uzmansizlar.isNotEmpty) {
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      /* Her bir uzmansız seansı tek tek ekrana yazar. */
      for (var u in uzmansizlar) {
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    /* Raporun kapanış çizgisini yazdırır. */
    print("---------------------------------------");
  }
  /* KlinikYoneticisi sınıfının kapanış süslü parantezisidir. */
}

/* -------------------------------------------------------------------------- */
/* 5. UYGULAMA BAŞLANGICI (MAIN)                                             */
/* -------------------------------------------------------------------------- */

/* Uygulamanın çalışmaya başladığı ana fonksiyondur. */
void main() {
  /* Sistemin başlatıldığını belirten bilgi mesajını konsola yazdırır. */
  print("Klinik yönetim sistemi başlatılıyor....");
  /* Belirtilen şube adı ile klinik yöneticisi nesnesini oluşturur. */
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi");

  /* Test amaçlı birinci danışan nesnesini tanımlar. */
  final d1 = Danisan(
    /* Danışanın ID bilgisini atar. */
    id: "DAN-101",
    /* Danışanın ad soyad bilgisini atar. */
    adSoyad: "Ahmet Yılmaz",
    /* Danışanın telefon numarasını atar. */
    telefon: "0555 555 55 55",
    /* Danışanın VIP üye olduğunu belirtir. */
    vipUyeMi: true,
    /* Danışanın alerji listesini tanımlar. */
    alerjiler: ["Retinol", "Aspirin"],
    /* Danışanın özel cilt notunu girer. */
    ozelCiltNotu: "Cilt bariyeri hassas",
    /* Danışan tanımının kapanış parantezisidir. */
  );

  /* Test amaçlı ikinci danışan nesnesini tanımlar. */
  final d2 = Danisan(
    /* Danışanın ID bilgisini atar. */
    id: "DAN-102",
    /* Danışanın ad soyad bilgisini atar. */
    adSoyad: "Ahmet Yılan",
    /* Danışanın telefon numarasını atar. */
    telefon: "0555 555 55 55",
    /* Danışanın VIP olmadığını belirtir. */
    vipUyeMi: false,
    /* Danışanın alerji listesini boş bırakır. */
    alerjiler: [],
    /* Danışan tanımının kapanış parantezisidir. */
  );

  /* Test amaçlı üçüncü danışan nesnesini tanımlar. */
  final d3 = Danisan(
    /* Danışanın ID bilgisini atar. */
    id: "DAN-103",
    /* Danışanın ad soyad bilgisini atar. */
    adSoyad: "Mehmet Yılmaz",
    /* Danışanın telefon numarasını atar. */
    telefon: "0555 555 55 55",
    /* Danışanın VIP üye olduğunu belirtir. */
    vipUyeMi: true,
    /* Danışanın alerji listesini tanımlar. */
    alerjiler: ["Retinol", "Aspirin"],
    /* Danışan tanımının kapanış parantezisidir. */
  );

  /* Test amaçlı dördüncü danışan nesnesini tanımlar. */
  final d4 = Danisan(
    /* Danışanın ID bilgisini atar. */
    id: "DAN-104",
    /* Danışanın ad soyad bilgisini atar. */
    adSoyad: "Ahmet Mehmet Yılmaz",
    /* Danışanın telefon numarasını atar. */
    telefon: "0555 555 55 55",
    /* Danışanın VIP üye olduğunu belirtir. */
    vipUyeMi: true,
    /* Danışanın alerji listesini boş bırakır. */
    alerjiler: [],
    /* Danışanın özel cilt notunu girer. */
    ozelCiltNotu: "Cilt bariyeri hassas",
    /* Danışan tanımının kapanış parantezisidir. */
  );

  /* Birinci danışanı yönetici rehberine kaydeder. */
  yonetici.danisanKaydet(d1);
  /* İkinci danışanı yönetici rehberine kaydeder. */
  yonetici.danisanKaydet(d2);
  /* Üçüncü danışanı yönetici rehberine kaydeder. */
  yonetici.danisanKaydet(d3);
  /* Dördüncü danışanı yönetici rehberine kaydeder. */
  yonetici.danisanKaydet(d4);

  /* Güvenlik kontrolü başlığını yazdırır. */
  print("Danışan güvenlik kontrolü");
  /* Birinci danışanın özet bilgi metnini ekrana yazdırır. */
  print(d1.bilgiOzeti);
  /* İkinci danışanın özet bilgi metnini ekrana yazdırır. */
  print(d2.bilgiOzeti);
  /* Ayırıcı çizgiyi ekrana yazdırır. */
  print("----------------------------------");

  /* Birinci seans kaydı nesnesini oluşturur. */
  final seans1 = SeansKaydi(
    /* Seans kodunu atar. */
    seansKodu: "SNS-2026-1",
    /* İlgili danışanı bağlar. */
    danisan: d1,
    /* Hizmet kategorisini seçer. */
    kategori: HizmetKategorisi.Lipo,
    /* İşlem adını yazar. */
    islemAdi: "Lipo gerisini bilmiyorum",
    /* Birim fiyatını belirler. */
    birimFiyat: 6500.0,
    /* Seans sayısını yazar. */
    seansSayisi: 2,
    /* İndirim oranını belirler. */
    indirimOrani: 5.0,
    /* Sorumlu uzman adını atar. */
    sorumluUzman: "Sümeyye Arab",
    /* Seans tanımının kapanış parantezisidir. */
  );

  /* İkinci seans kaydı nesnesini oluşturur. */
  final seans2 = SeansKaydi(
    /* Seans kodunu atar. */
    seansKodu: "SNS-2026-2",
    /* İlgili danışanı bağlar. */
    danisan: d2,
    /* Hizmet kategorisini seçer. */
    kategori: HizmetKategorisi.ciltYenileme,
    /* İşlem adını yazar. */
    islemAdi: "Siverex ile yüz temizleme",
    /* Birim fiyatını belirler. */
    birimFiyat: 2500.0,
    /* Seans sayısını yazar. */
    seansSayisi: 5,
    /* İndirim oranını belirler. */
    indirimOrani: 15.0,
    /* Sorumlu uzmanın olmadığını (null) belirtir. */
    sorumluUzman: null,
    /* Seans tanımının kapanış parantezisidir. */
  );

  /* Üçüncü seans kaydı nesnesini oluşturur. */
  final seans3 = SeansKaydi(
    /* Seans kodunu atar. */
    seansKodu: "SNS-2026-3",
    /* İlgili danışanı bağlar. */
    danisan: d3,
    /* Hizmet kategorisini seçer. */
    kategori: HizmetKategorisi.lazerEpilasyon,
    /* İşlem adını yazar. */
    islemAdi: "Tüm Vücut",
    /* Birim fiyatını belirler. */
    birimFiyat: 25000.0,
    /* Seans sayısını yazar. */
    seansSayisi: 15,
    /* İndirim oranını 0.0 olarak atar. */
    indirimOrani: 0.0,
    /* Sorumlu uzman adını atar. */
    sorumluUzman: "Tuba Aydın",
    /* Seans tanımının kapanış parantezisidir. */
  );

  /* Dördüncü seans kaydı nesnesini oluşturur. */
  final seans4 = SeansKaydi(
    /* Seans kodunu atar. */
    seansKodu: "SNS-2026-4",
    /* İlgili danışanı bağlar. */
    danisan: d4,
    /* Hizmet kategorisini seçer. */
    kategori: HizmetKategorisi.medikalEstetik,
    /* İşlem adını yazar. */
    islemAdi: "Burun Estetiği",
    /* Birim fiyatını belirler. */
    birimFiyat: 1500.0,
    /* Seans sayısını yazar. */
    seansSayisi: 3,
    /* Sorumlu uzman adını atar. */
    sorumluUzman: "Alaaddin Odabaşı",
    /* Seans tanımının kapanış parantezisidir. */
  );

  /* Birinci seansı yöneticiye gönderip sisteme ekler. */
  yonetici.randevuOlustur(seans1);
  /* İkinci seansı yöneticiye gönderip sisteme ekler. */
  yonetici.randevuOlustur(seans2);
  /* Üçüncü seansı yöneticiye gönderip sisteme ekler. */
  yonetici.randevuOlustur(seans3);
  /* Dördüncü seansı yöneticiye gönderip sisteme ekler. */
  yonetici.randevuOlustur(seans4);
  /* Seansların gönderildiğini belirten bilgi mesajını yazdırır. */
  print("Seanslar Gönderiliyor");

  /* Seans 1'i kredi kartı ödemesi ile başarıyla tamamlar. */
  yonetici.seansiTamamla(
    /* İşlem yapılacak seans kodunu belirtir. */
    seansKodu: "SNS-2026-1",
    /* Ödeme yöntemini kredi kartı olarak seçer. */
    odeme: OdemeYontemi.krediKarti,
    /* Metot çağrısının kapanış parantezisidir. */
  );

  /* Seans 2'yi nakit ödeme ile başarıyla tamamlar. */
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);

  /* Seans 4'ü belirtilen iptal gerekçesi ile iptal eder. */
  yonetici.seansiIptalEt(
    /* İptal edilecek seans kodunu yazar. */
    "SNS-2026-4",
    /* İptal nedenini metin olarak belirtir. */
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
    /* Metot çağrısının kapanış parantezisidir. */
  );

  /* Gün sonu raporunu konsola yazdırmak için ilgili metodu çağırır. */
  yonetici.gunSonuRaporuYazdir();
  /* main fonksiyonunun kapanış süslü parantezisidir. */
}
