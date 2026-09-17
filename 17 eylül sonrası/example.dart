//-- 1. Bölüm TABLOSU DEPARTMENT;

 //Hocam, normalizasyon kuralları gereği aynı metinleri 
 // yüzlerce öğrencinin satırında tekrar tekrar yazarak 
 //veri kalabalığı  yaratmamak için
 // bölümü ayrı bir tabloya çıkardık. Her bölümün eşsiz bir id numarası var
 //Bölüm adlarını tek bir yerde toplamak için.


CREATE TABLE IF NOT EXISTS departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name TEXT UNIQUE NOT NULL
);


//2. Öğrenci Tablosu Students 

//Öğrencinin numarasını ve adını tutar.
//Hangi bölümde okuduğunu ise doğrudan metin olarak değil,
// department_id üzerinden bölüm tablosuna bağlanarak tutar.
//Hocam burada 3NF kuralını uyguladık.
// Öğrenci tablosunda sadece öğrencinin kendi bilgileri var.
// Hangi bölümde okuduğu bilgisini tutarken department_id kullanarak
// departments tablosuna yabancı anahtar (FOREIGN KEY) ile bağladık. 
//Böylece bir bölümün adı değişirse
// sadece ana tablodan değiştirmemiz yeterli olur,
// her öğrenciyi tek tek güncellemek zorunda kalmayız
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);

//3. Ders Tablosu Courses 

//Hocam tıpkı öğrenciler gibi dersler de
// hangi bölüme aitse department_id ile bağlıdır.
 //Ayrıca CHECK(credit > 0) kuralı koyduk;
 // yani sisteme negatif veya 0 kredi ders eklenmesini veritabanı seviyesinde engelledik

CREATE TABLE IF NOT EXISTS courses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    credit INTEGER NOT NULL CHECK(credit > 0),
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
);


///Hocam, veriyi 3NF kurallarına uygun hale getirmek için 
//bölüm isimlerini öğrenci tablosunda tekrar tekrar yazarak 
//veri kalabalığı yaratmadık. departments adında ana bir tablo açtık.
// students tablosuna sadece department_id koyarak yabancı anahtar (FOREIGN KEY) ile 
//iki tabloyu mantıksal olarak birbirine bağladık.
// Böylece ileride bölüm adında bir değişiklik olursa sadece tek bir yerden
// güncelleyebiliyoruz.