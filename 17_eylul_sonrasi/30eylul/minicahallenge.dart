mixin DalmaYetisi {
  void dalisYap() {
    print("su altına daldı");
  }
}

class Denizci with DalmaYetisi {}

void main() {
  final denizciKarakter = Denizci();
  denizciKarakter.dalisYap();
}
