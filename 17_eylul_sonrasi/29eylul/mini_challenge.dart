void main() {
  final bool isProduction = true;
  final Set<String> temelServisler = {
    "api-gateway",
    "auth-service",
    "api-gateway", // Yinelenen eleman Set bunu otomatik siler!
  };

  final List<String> nihaiDagitimKumesi = [
    ...temelServisler,
    if (isProduction) "vault-secret-manager",
  ];

  print("Dağıtım Kümesi: $nihaiDagitimKumesi");
}

/* void main() {
    // 1. Mükerrer (aynı isimden birden fazla) kayıtları engelleyen Set tanımı
    Set<String> cloudServisleri = {
      "giris-servisi",
      "odeme-servisi",
      "giris-servisi",
    };

    // 2. Ortamın canlı (prodüksiyon) olup olmadığını belirten bayrak
    bool isProduction = true;

    // 3. Collection if (şartlı ekleme) kullanarak List oluşturma
    List<String> tumServisler = [
      "giris-servisi",
      "odeme-servisi",
      // Eğer isProduction true ise bu servisi listeye ekle, değilse ekleme!
      if (isProduction) "vault-secret-manager",
    ];
    // 4. Sonucu ekrana yazdırma
    print(tumServisler);
  }*/
