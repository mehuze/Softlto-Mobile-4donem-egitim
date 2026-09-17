

//tablo oluşumu
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL
);

//kayıt 
INSERT INTO users (full_name, email)
VALUES
('zeynep mina tür', 'zeynep@gmail.com'),
('meryem tür', 'meryem@gmail.com'),
('elif bade', 'elif@gmail.com');

//kontrol için bu tablo oluştu mu ,kayırlar var mı
SELECT * FROM users;

//güncelleme
UPDATE users
SET email = 'meryem tür@gmail.com'
WHERE id = 2;

// silme 
DELETE FROM users
WHERE id = 3;

//inner join nedir?=

//users tablosu
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL
);

//orders tablosu
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    order_number TEXT
);

 //inner join
SELECT
    users.full_name,
    users.email,
    orders.order_number       

FROM users

INNER JOIN orders

ON users.id = orders.user_id;
// gelelim mantığına 

//İki liste var. Biri kullanıcı , biri siparişler.meryem sipariş vermiş olsun
//kullanıcı id = 1  meryem
//sipariş user_id= 1 pizza
//1=1 olduğu için meryemin pizza siparişi var dedi yani taboları birletirdi 
//INNER JOIN, aynı numaraya sahip olanları bulup eşleştiriyor.
//Önce users.id ile orders.user_id değerlerini eşleştirip ortak kayıtları buluyoruz,
 //sonra SELECT ile bu kayıtların hangi bilgilerini göstereceğimizi seçiyoruz.
 //ON = Neye göre eşleştireyim?
 //INNER JOIN = Sadece eşleşenleri getir.



/*a) Ekran görüntüsü ve ekran kaydı
Banka uygulamasında kart numarası veya bakiye göründüğü için .
Eğer ekran görüntüsü alınırsa veya ekran kaydı yapılırsa, 
başka biri bu bilgileri görebilir.buda guvenlik için sorun olur önlemk için;
Örneğin Android'de bunun için:
FLAG_SECURE
iOS:UIScreen.isCaptured
kullanılır. Ekran görüntüsü ve ekran kaydını engellemeye yardımcı oluyor.
*/


/*b) Overlay saldırıları

Telefon ekranında banka uygulaması açık.

Saldırgan, onun üzerine sahte bir buton koyuyor:

 “Şifrenizi doğrulamak için buraya tıklayın.”

Kullanıcı gerçek banka,
 uygulamasında olduğunu sanıp tıklıyor ve bilgilerini saldırgana verebiliyor.
 peki nasıl önlenir :Overlay saldırısında mesele ekranın üstüne başka bir şey gelmesi.
 Root gibi telefonu açmıyoruz.Özellikle hassas butonlarda touch güvenliği
  için Android'de filterTouchesWhenObscured gibi bir özellik kullanıyoruz


 */
  /*c) Root / Jailbreak
Root edilmiş veya Jailbreak yapılmış bir cihaz neden normal bir cihaza göre daha risklidir?
 bir ornekle düşünelim:bir okul örneği düşünelim. Okulların kapıları kilitli.
  Bu normal bir telefon olsun. Öğrenci sadece izin verilen sınıflara girebiliyor
  . Ama telefon root, jailbreak yapılırsa bazı kilitler açılmış gibi düşünelim.
   Örneğin telefonda bir banka uygulaması var.
    Normalde bu uygulamanın dosyalarına giremeyiz.
     Ama root, jailbreak sonrasında sistemin bazı korumaları aşabildiği için 
     bu dosyalara ulaşmaya veya değiştirmeye çalışabiliriz.
     Yani kısaca telefonun normalde kapalı olan kapılarının bazılarını açmak.
     */


/*d) SQLite ve şifreleme
Bunun da bir örnek yapalım,mesela  bir kumbara düşünelim.
 Kumbaranın içine Meryem 1 2 3 4 5 6 yazıyor olsun. 
  Ama kumbaranın kapağı kapalı, kilitli olmasın. 
  Şimdi birisi kumbarayı eline geçirirse eğer,
   A, içinde Meryem 1 2 3 4 5 6 yazıyor diyebilir. 
   Yani böyle diyerek direkt okur. Ama eğer biz kumbaraya kilit takarsak,
    içinde bilgiler hâlâ var ama dışarıdan bakan kişi
     onları normal şekilde okuyamaz. İşte bunu sağlayan şey de SQL Cipher.
      Yani SQLite ait bilgileri saklıyor. SQL Cipher ise
       SQLite bilgilerini şifreleyerek saklıyor. Yani biri kutuysa,
        öteki kutunun kilidi.
        */




      // Access Token ve Refresh Token 
      /*bunuda bir örnekle açıklayacağım:
      Şimdi bir tane lunapark bileti düşünelim.
       Lunaparka girdik. Yani bu access token, giriş biletimiz.
        Görevliye bak benim biletim var dedik. İçeriye girdik.
         Ama bu biletin süresi kısa. Mesela 10 dakika sonra bilet geçersiz.
          Neden? Biri biletimizi çalarsa en azından sadece kısa bir süre
           kullanabilir. Peki Refresh Token ne demek?
            Bilet gişesindeki özel kart. Access token'ın süresi bitti.
             Tekrar gişeye gidiyor. Refresh token'ı gösteriyor. 
             Bana yeni bir access token verir misin diyor.
              Gişe sana yeni bir access token veriyor. 
              Bu yüzden Refresh token daha değerli ve daha güvenli saklanıyor.

              Access Token neden kısa süreli?
              Çalınırsa saldırganın kullanabileceği süreyi sınırlamak için.

              Refresh Token neden güvenli yerde saklanır?
            Yeni Access Token almayı sağladığı için daha değerlidir;
             bu yüzden korunmalıdır.

             kullanıcı çıkış yaptığında neden refresh token iptall edilebilir ?
             Refresh token, yedek anahtar gibi düşünelim.
              Kullanıcı çıkış yaptığında anahtarı iptal ediyor. 
              Peki neden böyle oluyor? 
              Kullanıcı çıkış yaptıktan sonra 
              eski refresh token birinin eline geçerse
               yeni access token alıp tekrar giriş yapamasın diye.
                İşte bu işleme de logout deniyor
              */
