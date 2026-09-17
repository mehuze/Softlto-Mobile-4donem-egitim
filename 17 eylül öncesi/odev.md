//sözde kod

adım1 başla
adım2:uygulamayı aç
adım3:kullanıcı giriş yapmış mı?
adım4:eğer hayır ise giriş ekranına yönlendir
adım5:giriş yap
adım6:eğer evet ise ürünleri göster
adım7:ürünleri seç
adım8:sepete ekle
adım9:başaka ürün var mı bak
adım10: eğer var ise evet ise ürün şeç ekrana gir
adım11:eğer hayır ise sepet toplamını hesapla
adım12:bakiye yeterli mi?
adım13:eğer hayır ise bakiye yükle
adım14:tekrar sepet toplamını hesapla
adım15:eğer evet ise siparişi onayla
adım16:bakiyeden düş
adım17:sipariş paketini sunucuya gönder
adım18:bitir

görev 2
idempotent nedir?
istek tekrar tekrar gönderildiğinde sistemde ekstra bir değişiklik, ekstra bir kayıt ya da yan etki oluşmuyorsa, o istek idempotenttir.
peki hangisi değil neden?

POST isteği  idempotent değil, her çalıştırıldığında sunucuda yeni bir kayıt oluşturuyor. Yani /api/v1/siparisler endpoint'ine aynı isteği 3 kere gönderirsem, sistemde 3 farklı sipariş oluşur. Bu yüzden POST isteği idempotent değildir, çünkü tekrar tekrar gönderildiğinde sonuç her seferinde değişiyor (yeni sipariş ekleniyor).

ama GET isteği idempotenttir.Bunun sebebi şu: GET isteği sadece veri okumak için kullanılıyor, yani ben /api/v1/kullanici/bakiye endpoint'ine bu isteği ister 1 kere ister 10 kere göndereyim, sunucudaki hiçbir şeyi değiştirmiyor, her seferinde bana aynı bakiye bilgisini döndürüyor.


görev 3

1. SRP (Single Responsibility Principle) İhlali
Bu sınıf tek başına birden fazla sorumluluk üstlenmiş.sepet hesaplama, ödeme (kredi kartı tahsilatı), veritabanı işlemleri ve bildirim (SMS) gönderme gibi birbirinden tamamen farklı işleri aynı sınıfın içinde yapıyor.Bu yüzden sınıf,ayrı sınıflara bölünmelidir.Eğer böyle yapılırsa her sınıf yalnızca kendi işinden sorumlu olur.


2. OCP (Open/Closed Principle) İhlali
indirimHesapla fonksiyonundaki if-else yapısı,Çünkü bu prensibe göre bir kod yeni özellik eklemeye açık,değiştirmeye kapalı olmalıdır.ama burada yeni bir müşteri tipi eklemek için mevcut fonksiyonun içine girip if-else zincirini değiştirmemiz gerekiyor, bu da var olan çalışan kodu bozabilirr.Bunun yerine her müşteri tipi için ayrı bir indirim sınıfı tanımlanıp  yeni müşteri tipi geldiğinde mevcut kodu değiştirmeden sadece yeni bir sınıf eklenmesi gerekir.

![KahveGo Akış Şeması](kahve%20sipariş%20uygulaması%20şema.jpg)

hocam ödev yukleme tarihi gectiği için durumu biliyorsunuz video bitti ve odevleri bugun bitirdim buradan yukluyorum şemanın görünmesi için araştırdım yeni bir yol öğrendim bu kodu eklemek grekiyormuş tıklayınca yaptıgım semayı göreceksiniz anlayısnız için tesekkur ederim .
