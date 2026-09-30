abstract class SoyutCanavar {
  final String isim;

  SoyutCanavar({required this.isim});

  void kukre();
}

class KurtCanavari extends SoyutCanavar {
  KurtCanavari({required super.isim});

  @override
  void kukre() {
    print("[$isim] Awoooo! Orman inliyor:  Uluma sesi!");
  }
}

class EjderhaCanavari extends SoyutCanavar {
  EjderhaCanavari({required super.isim});

  @override
  void kukre() {
    print("[$isim] Rooooar! Yer yerinden oynadı: Alevler saçarak kükredi!");
  }
}

/*void main() {
  print("--- Canavar Mağarasına Hoş Geldiniz ---");

  final kurt = KurtCanavari(isim: "Gümüş Diş");
  final ejderha = EjderhaCanavari(isim: "T-rex");

  kurt.kukre();
  ejderha.kukre();
}
abstract class Canavar {
  void kukre();
}

class KurtCanavari extends Canavar {
  @override
  void kukre() {
    print(" Avuuuu! Kurt uludu.");
  }
}

class EjderhaCanavari extends Canavar {
  @override
  void kukre() {
    print(" ROAAAR! Ejderha yeri göğü inletti.");
  }
}*/
