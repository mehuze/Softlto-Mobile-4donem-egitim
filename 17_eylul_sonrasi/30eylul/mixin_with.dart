//mixin an with
/*Mixin Yapısı (mixin UcmaYetisi): Dart dilinde sınıflar sadece tek bir sınıftan miras alabilirler (extends). 
Ancak bazı yetenekleri (örneğin uçmak, yüzmek, görünmez olmak) birden fazla ve birbirinden bağımsız
 sınıflara kazandırmak isteyebiliriz. İşte mixin tam olarak bu işe yarar; kalıtım hapsine girmeden bir "yetenek paketi" oluşturmamızı sağlar.*/
mixin UcmaYetisi {
  int ucusIrtifasiMetre = 100;

  void gogeYuksel() {
    print(
      "Uçuş Yetisi: Kanatlarını Açtı ve $ucusIrtifasiMetre metreye Yükseldi",
    );
  }
}

mixin GorunmezlikYetisi {
  void pelerinOrt() {
    print("Görünmezlik: Düşmanların gözünden tamamen kayboldu!");
  }
}

mixin AtesGucuYetisi {
  void alevSaldirisi() {
    print("Ateş Gücü: Kılıcını alevlendirdi ve alanı yaktı");
  }
}

class TemelKarakter {
  final String ad;
  TemelKarakter({required this.ad});
}

class EfsaneviEjderBinicisi extends TemelKarakter
    with UcmaYetisi, AtesGucuYetisi {
  final String ejderhaAdi;

  EfsaneviEjderBinicisi({required this.ejderhaAdi, required super.ad});

  void hucumEt() {
    print("$ad ve ejderhası $ejderhaAdi savaşa atılıyor");
    gogeYuksel();
    alevSaldirisi();
  }
}

class GolgeSuikastci extends TemelKarakter with GorunmezlikYetisi {
  GolgeSuikastci({required super.ad});

  void suikastYap() {
    print("$ad hedefe sessizce yaklaşıyor");
    pelerinOrt();
    print("Kritik Darbe Vurdu");
  }
}

void main() {
  print("Süper Güçler Başlatılıyor");
  final birinci = EfsaneviEjderBinicisi(ejderhaAdi: "Aslıhan", ad: "Gencer");
  birinci.hucumEt();
  final ikinci = GolgeSuikastci(ad: "AdilMurat");
  ikinci.suikastYap();
}
