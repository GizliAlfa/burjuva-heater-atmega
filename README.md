# Burjuva Heater - ATmega Sıcaklık Kontrol Sistemi

## 📖 Proje Hakkında

Bu proje, **ATmega mikrodenetleyici** (Arduino) tabanlı profesyonel bir **ısıtıcı kontrol sistemi**dir. PT1000 sıcaklık sensörü kullanarak hassas sıcaklık ölçümü yapar ve PID kontrol algoritması ile hedef sıcaklığı korur.

## 🎯 Ne İşe Yarar?

Sistem, bir ısıtıcıyı (örneğin rezistans, bant ısıtıcı) otomatik olarak kontrol ederek belirlediğiniz sıcaklığı sabit tutar. Tıpkı bir fırının veya su ısıtıcısının termostatı gibi çalışır, ancak çok daha hassas ve programlanabilir.

### Kullanım Alanları:
- Endüstriyel ısıtma sistemleri
- 3D yazıcı ısıtıcı tabla kontrolü
- Laboratuvar ekipmanları
- Plastik şekillendirme makineleri
- Gıda işleme ekipmanları

## 🔧 Donanım Gereksinimleri

### Elektronik Bileşenler:
- **Arduino** (ATmega328P veya benzeri)
- **ADS1115** - 16-bit ADC modülü (hassas sıcaklık ölçümü için)
- **PT1000** - Sıcaklık sensörü (4 kanala kadar desteklenir)
- **SSR (Solid State Relay)** - Yüksek güçlü ısıtıcıyı anahtarlamak için
- **938Ω Referans Direnci** - PT1000 sensör devresi için
- **5V Güç Kaynağı**

### Bağlantı Şeması:
```
Arduino ---[I2C]--- ADS1115 ---[Analog]--- PT1000 Sensör Devresi
   |
   +---[Digital Pin 8]--- SSR --- Isıtıcı
   |
   +---[UART]--- Bilgisayar (Seri Port)
```

## ⚙️ Teknik Özellikler

### Sıcaklık Kontrolü:
- **Maksimum sıcaklık**: 350°C
- **Varsayılan hedef**: 100°C
- **Hassasiyet**: ±0.3°C (deadband)
- **Okuma aralığı**: 300ms

### PID Parametreleri:
- **Kp (Oransal)**: 26.0
- **Ki (İntegral)**: 0.05
- **Kd (Türevsel)**: 4.0
- **Güncelleme hızı**: 300ms
- **İntegral sınırı**: ±300
- **İntegral aktif aralığı**: ±2°C

### PWM Kontrol:
- **SSR frekansı**: 30 Hz
- **Çözünürlük**: 0-100% (yumuşak PWM)
- **Pin**: Digital 8

### İletişim:
- **Seri Port hızı**: 115200 baud
- **Protokol**: Basit metin tabanlı

## 🚀 Kurulum

### 1. Arduino IDE Kurulumu
1. Arduino IDE'yi indirin ve kurun
2. Gerekli kütüphaneleri yükleyin:
   - `Adafruit_ADS1X15`
   - `Wire` (Arduino ile birlikte gelir)

### 2. Kodu Yükleme
```bash
# Projeyi klonlayın veya indirin
# Arduino IDE'de main.ino dosyasını açın
# Board: Arduino Uno (veya kullandığınız model) seçin
# Port'u seçin ve Upload butonuna basın
```

### 3. Donanım Bağlantısı
1. ADS1115 modülünü I2C üzerinden bağlayın (SDA, SCL)
2. PT1000 sensörü ADS1115'in kanal 2'ye bağlayın
3. SSR'yi Digital Pin 8'e bağlayın
4. Güç bağlantılarını yapın

## 📊 Sistem Durumları

Sistem 4 farklı durumda çalışır:

| Durum | Açıklama |
|-------|----------|
| **SYS_INIT** | Başlangıç - Sensör kontrolü yapılıyor |
| **SYS_READY** | Hazır - Isıtma başlatılmayı bekliyor |
| **SYS_RUN** | Çalışıyor - Aktif ısıtma ve kontrol |
| **SYS_ERROR** | Hata - Sistem güvenli modda |

## 🛡️ Hata Kodları ve Güvenlik

Sistem aşağıdaki hataları otomatik algılar ve ısıtıcıyı kapatır:

| Kod | Hata | Açıklama |
|-----|------|----------|
| **ERR_NONE** | Hata yok | Normal çalışma |
| **ERR_SENSOR_NOT_READY** | Sensör hazır değil | ADS1115 bulunamadı |
| **ERR_SENSOR_DISCONNECTED** | Sensör kopuk | PT1000 bağlantısı kesildi |
| **ERR_OVERTEMP** | Aşırı ısınma | Güvenlik sınırı aşıldı |
| **ERR_ADC_FAILURE** | ADC hatası | ADS1115 ile iletişim kesildi |

> ⚠️ **ÖNEMLİ**: Herhangi bir hata durumunda SSR otomatik olarak kapanır ve ısıtıcı devre dışı kalır.

## 💻 Seri Port Komutları

Sistem **115200 baud** hızında UART üzerinden iletişim kurar. Hem komut alır hem de durum bilgisi gönderir.

### 📥 Gelen Komutlar (Arduino'ya Gönderilen)

Sistem aşağıdaki komutları destekler. Tüm komutlar **case-sensitive**'dir ve satır sonu (`\n`) ile bitmelidir.

#### 1. Hedef Sıcaklık Ayarlama

**Format**: `T:<değer>` veya sadece `<değer>`

**Örnekler**:
```
T:150      // Hedefi 150°C'ye ayarla
T:200.5    // Hedefi 200.5°C'ye ayarla
85         // Hedefi 85°C'ye ayarla (eski format)
```

**Kurallar**:
- Değer **0 ile 500 arasında** olmalı
- Maksimum sıcaklık `HEATER_MAX_TEMP` (350°C) ile sınırlıdır
- Geçersiz değerler reddedilir ve hata mesajı döner

**Yanıt**: `Target set to: 150.0`

---

#### 2. PID Parametrelerini Ayarlama

**Format**: `P:<kp>,<ki>,<kd>`

**Örnek**:
```
P:26.0,0.05,4.0
P:30,0.1,5
```

**Açıklama**:
- Kp: Oransal kazanç
- Ki: İntegral kazanç
- Kd: Türevsel kazanç
- Virgülle ayrılmış 3 değer gerekli
- PID otomatik olarak reset edilir

**Yanıt**: `PID set to Kp:26.000 Ki:0.050 Kd:4.000`

> ⚠️ **Not**: Değişiklikler geçicidir. Kalıcı yapmak için `SAVE` komutu kullanın.

---

#### 3. Isıtmayı Aç/Kapa

**Format**: `H:<0|1>`

**Örnekler**:
```
H:1        // Isıtmayı aç (enable)
H:0        // Isıtmayı kapat (disable)
```

**Açıklama**:
- `H:1` → Sistem RUN moduna geçer ve ısıtma başlar
- `H:0` → Sistem READY moduna döner, ısıtıcı kapanır

**Yanıt**: `Heating enabled` veya `Heating disabled`

---

#### 4. EEPROM'a Kaydet

**Format**: `SAVE`

**Örnek**:
```
SAVE
```

**Açıklama**:
- Mevcut PID parametrelerini EEPROM'a kaydeder
- Arduino yeniden başlatıldığında bu değerler otomatik yüklenir
- Kalıcı değişiklik yapar

**Yanıt**: `PID parameters saved to EEPROM`

---

#### 5. PID Reset

**Format**: `PIDRESET`

**Örnek**:
```
PIDRESET
```

**Açıklama**:
- PID kontrol değişkenlerini sıfırlar (integral, türev)
- Parametreleri değiştirmez
- Aşırı salınım veya kararsızlık durumunda kullanışlı

**Yanıt**: `PID reset`

---

#### 6. Sistem Reset

**Format**: `RESET`

**Örnek**:
```
RESET
```

**Açıklama**:
- Arduino'yu tamamen yeniden başlatır (watchdog reset)
- Tüm geçici değişkenler sıfırlanır
- EEPROM'daki veriler korunur

**Yanıt**: `System resetting...` (sonra yeniden başlar)

---

#### 7. Detaylı Durum Bilgisi

**Format**: `STATUS`

**Örnek**:
```
STATUS
```

**Yanıt**:
```
===== SYSTEM STATUS =====
System State: RUN
Error Code: 0 - No Error
PID: Kp=26.000 Ki=0.050 Kd=4.000
Target: 150.0°C
Heating: Enabled
========================
```

---

#### 8. Yardım Menüsü

**Format**: `HELP`

**Örnek**:
```
HELP
```

**Yanıt**: Tüm komutların listesi ve kullanımı

---

### � Kullanım Örnekleri

#### Arduino Serial Monitor'den:
1. Serial Monitor'ü açın (Ctrl+Shift+M)
2. Baud rate'i **115200** yapın
3. "Both NL & CR" veya "Newline" seçin
4. Komut yazıp Enter'a basın

```
T:150          ← Hedef sıcaklık ayarla
STATUS         ← Durum görüntüle
P:30,0.1,5     ← PID ayarla
SAVE           ← Kaydet
```

#### Python'dan Komut Gönderme:
```python
import serial
import time

ser = serial.Serial('COM3', 115200, timeout=1)
time.sleep(2)

# Hedef sıcaklık ayarla
ser.write(b'T:150\n')
time.sleep(0.1)
print(ser.readline().decode().strip())  # Yanıtı oku

# PID ayarla
ser.write(b'P:26.0,0.05,4.0\n')
time.sleep(0.1)
print(ser.readline().decode().strip())

# Kaydet
ser.write(b'SAVE\n')
time.sleep(0.1)
print(ser.readline().decode().strip())

# Isıtmayı başlat
ser.write(b'H:1\n')
time.sleep(0.1)
print(ser.readline().decode().strip())

ser.close()
```

#### Python ile İnteraktif Kontrol:
```python
import serial
import time

def send_command(ser, cmd):
    ser.write((cmd + '\n').encode())
    time.sleep(0.1)
    while ser.in_waiting:
        print(ser.readline().decode().strip())

ser = serial.Serial('COM3', 115200, timeout=1)
time.sleep(2)

while True:
    cmd = input("Command: ")
    if cmd == 'exit':
        break
    send_command(ser, cmd)

ser.close()
```

---

### �📤 Giden Veriler (Arduino'dan Gelen)

#### 1. Durum Bilgisi (Otomatik)
Sistem her **300ms**'de bir otomatik olarak durum bilgisi gönderir.

**Format**:
```
T:<sıcaklık> SP:<hedef> D:<duty> STATE:<durum> ERR:<hata>
```

**Örnek Çıktılar**:
```
T:98.45 SP:100.0 D:45.2 STATE:2 ERR:0
T:150.32 SP:150.0 D:12.8 STATE:2 ERR:0
T:-999.00 SP:100.0 D:0.0 STATE:3 ERR:2
```

**Alanların Anlamları**:

| Alan | Açıklama | Birim | Örnek Değer |
|------|----------|-------|-------------|
| **T** | Mevcut sıcaklık | °C | `98.45` |
| **SP** | Hedef sıcaklık (SetPoint) | °C | `100.0` |
| **D** | PWM duty cycle (güç) | % | `45.2` |
| **STATE** | Sistem durumu kodu | - | `2` (SYS_RUN) |
| **ERR** | Hata kodu | - | `0` (ERR_NONE) |

**Sistem Durum Kodları (STATE)**:
| Kod | Durum | Açıklama |
|-----|-------|----------|
| `0` | SYS_INIT | Başlangıç - Sensör kontrolü |
| `1` | SYS_READY | Hazır - Isıtma bekleniyor |
| `2` | SYS_RUN | Çalışıyor - Aktif ısıtma |
| `3` | SYS_ERROR | Hata - Güvenli mod |

**Hata Kodları (ERR)**:
| Kod | Hata | Açıklama |
|-----|------|----------|
| `0` | ERR_NONE | Hata yok |
| `1` | ERR_SENSOR_NOT_READY | ADS1115 hazır değil |
| `2` | ERR_SENSOR_DISCONNECTED | PT1000 kopuk |
| `3` | ERR_OVERTEMP | Aşırı ısınma |
| `4` | ERR_ADC_FAILURE | ADC iletişim hatası |
| `5` | ERR_UNKNOWN | Bilinmeyen hata |

#### 2. Veri Okuma Örnekleri

**Arduino Serial Monitor**:
```
T:25.34 SP:100.0 D:100.0 STATE:2 ERR:0    ← Isınıyor, tam güç
T:75.12 SP:100.0 D:85.3 STATE:2 ERR:0     ← Isınıyor, güç azalıyor
T:98.45 SP:100.0 D:45.2 STATE:2 ERR:0     ← Hedefe yakın, PID kontrolünde
T:99.85 SP:100.0 D:12.5 STATE:2 ERR:0     ← Hedefte, ince ayar
```

**Python ile Veri Okuma**:
```python
import serial
import time

ser = serial.Serial('COM3', 115200, timeout=1)
time.sleep(2)  # Arduino'nun hazırlanmasını bekle

while True:
    if ser.in_waiting > 0:
        line = ser.readline().decode('utf-8').strip()
        print(line)
        
        # Veriyi parse et
        if line.startswith('T:'):
            parts = line.split()
            temp = float(parts[0].split(':')[1])
            setpoint = float(parts[1].split(':')[1])
            duty = float(parts[2].split(':')[1])
            state = int(parts[3].split(':')[1])
            err = int(parts[4].split(':')[1])
            
            print(f"Sıcaklık: {temp}°C, Hedef: {setpoint}°C")
            print(f"Güç: %{duty}, Durum: {state}, Hata: {err}")
```

**Processing ile Grafiksel İzleme**:
```processing
import processing.serial.*;

Serial port;
float temperature = 0;
float setpoint = 0;
float duty = 0;

void setup() {
  size(800, 600);
  port = new Serial(this, "COM3", 115200);
}

void draw() {
  background(255);
  
  // Grafikler çiz
  fill(255, 0, 0);
  text("Sıcaklık: " + temperature + "°C", 10, 30);
  text("Hedef: " + setpoint + "°C", 10, 50);
  text("Güç: " + duty + "%", 10, 70);
}

void serialEvent(Serial port) {
  String data = port.readStringUntil('\n');
  if (data != null) {
    // Parse et ve değişkenlere ata
    // T:98.45 SP:100.0 D:45.2 STATE:2 ERR:0
    String[] parts = split(data, ' ');
    temperature = float(split(parts[0], ':')[1]);
    setpoint = float(split(parts[1], ':')[1]);
    duty = float(split(parts[2], ':')[1]);
  }
}
```

### 🔧 Komut Referansı

Yukarıda bahsedilen tüm komutlar **aktif olarak kodda mevcuttur**. Hiçbir değişiklik yapmadan kullanabilirsiniz:

#### ✅ Mevcut Komutlar:
- ✅ `T:<temp>` - Hedef sıcaklık ayarlama
- ✅ `P:<kp,ki,kd>` - PID parametreleri ayarlama
- ✅ `H:<0|1>` - Isıtmayı aç/kapa
- ✅ `SAVE` - EEPROM'a kaydet
- ✅ `PIDRESET` - PID reset
- ✅ `RESET` - Sistem reset
- ✅ `STATUS` - Detaylı durum bilgisi
- ✅ `HELP` - Yardım menüsü
- ✅ `<sayı>` - Hedef sıcaklık (eski format)

#### 💡 Yeni Komut Ekleme Örneği:

Eğer kendi komutlarınızı eklemek isterseniz, [uart.cpp](uart.cpp) dosyasında `uartTask()` fonksiyonunu genişletebilirsiniz:

```cpp
void uartTask() {
  if (!Serial.available()) return;
  
  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  
  // ... Mevcut komutlar ...
  
  // Yeni komut ekleyin:
  else if (cmd == "MYCOMMAND") {
    // Kendi kodunuz
    Serial.println("My custom response");
  }
  }
}

## 📁 Proje Yapısı

```
burjuva-heater-atmega/
│
├── main.ino              # Ana program (setup + loop)
│
├── config.h              # Sabit konfigürasyon ayarları
├── config_runtime.h/.cpp # Çalışma zamanı ayarları (EEPROM)
│
├── control.h/.cpp        # Ana kontrol döngüsü
├── pid.h/.cpp            # PID kontrol algoritması
│
├── pt1000.h/.cpp         # PT1000 sensör okuma (ADS1115)
├── io.h/.cpp             # SSR PWM kontrolü
├── uart.h/.cpp           # Seri port iletişimi
│
├── system_state.h/.cpp   # Durum makinesi ve hata yönetimi
└── error_codes.h         # Hata tanımları
```

## 🔄 Çalışma Mantığı

### 1. Başlangıç (setup):
```
Sistem Başlat → EEPROM Oku → UART Başlat → ADS1115 Başlat → PID Sıfırla → SSR Pin Ayarla
```

### 2. Ana Döngü (loop):
```
┌─────────────────────────────────────┐
│  UART Komutlarını Kontrol Et        │
│  (Hedef sıcaklık değişti mi?)       │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  Sistem Durumunu Güncelle           │
│  (Hata var mı? Hazır mı? Çalışıyor mu?)│
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  Sıcaklığı Oku (300ms'de bir)       │
│  ADS1115 → PT1000 → °C              │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  PID Hesapla                        │
│  Hata = Hedef - Mevcut              │
│  Çıkış = Kp×hata + Ki×∫hata - Kd×Δ  │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  SSR PWM Güncelle                   │
│  %0-100 güç kontrolü (30 Hz)        │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  UART Durum Gönder                  │
│  T:xx.xx SP:xx.x D:xx.x             │
└─────────────────────────────────────┘
```

## 🎛️ PID Kontrolü Nedir?

**PID** (Proportional-Integral-Derivative), hedef sıcaklığa hızlı ve kararlı ulaşmayı sağlayan bir kontrol algoritmasıdır:

- **P (Oransal)**: Hedefe ne kadar uzaksak, o kadar hızlı git
- **I (İntegral)**: Hedefe yaklaştıkça küçük hataları düzelt
- **D (Türevsel)**: Hedefe yaklaşırken yavaşla, salınımı önle

### Bu Sistemde:
- **Hedefe uzakken**: Tam güç ısıt (P baskın)
- **Hedefe yaklaşınca**: Yavaşla, aşmayı önle (D devreye girer)
- **Hedefte**: İnce ayar yap, sabit tut (I aktif)

## 🔐 EEPROM Hafıza

Sistem, PID parametrelerini EEPROM'a kaydeder. Arduino yeniden başlatıldığında son kullanılan PID değerleri otomatik yüklenir.

## ⚡ Güvenlik Özellikleri

1. **Aşırı Isınma Koruması**: Maksimum sıcaklık sınırı
2. **Sensör Kopma Algılama**: Bağlantı kesilirse ısıtıcı kapanır
3. **Watchdog**: ADC hatası algılanırsa güvenli mod
4. **Otomatik Kapatma**: Tüm hata durumlarında SSR devre dışı

## 🛠️ Ayarları Değiştirme

[config.h](config.h) dosyasından parametreleri değiştirebilirsiniz:

```cpp
// PID ayarları
#define PID_KP               26.0
#define PID_KI               0.05
#define PID_KD               4.0

// Isıtıcı ayarları
#define HEATER_TARGET_DEFAULT 100.0
#define HEATER_MAX_TEMP       350.0

// SSR PWM frekansı
#define SSR_PWM_HZ           30.0
```

## 🧪 Test ve Kalibrasyon

### İlk Çalıştırma:
1. Seri monitörü açın (115200 baud)
2. Düşük bir hedef sıcaklık ayarlayın (örn: 50°C)
3. Isıtıcının çalıştığını ve sıcaklığın yükseldiğini gözlemleyin
4. Hedef sıcaklığa ulaştığında PID kontrolünü izleyin

### PID Ayarlama:
Eğer sistem:
- **Hedefe çok yavaş gidiyorsa**: Kp'yi artırın
- **Salınım yapıyorsa**: Kd'yi artırın, Kp'yi azaltın
- **Hedefte sabit kalamıyorsa**: Ki'yi hafifçe artırın

## 📞 Sorun Giderme

| Sorun | Olası Neden | Çözüm |
|-------|-------------|--------|
| Sıcaklık -999 gösteriyor | Sensör bağlı değil | PT1000 bağlantısını kontrol edin |
| Isınma yok | SSR çalışmıyor | Pin 8 ve SSR bağlantısını kontrol edin |
| Aşırı salınım | PID ayarları yanlış | Kd'yi artırın, Kp'yi azaltın |
| Seri port veri yok | Baud rate yanlış | 115200 baud olduğundan emin olun |

## 📝 Lisans

Bu proje açık kaynak kodludur. Ticari veya kişisel projelerinizde özgürce kullanabilirsiniz.

## ⚠️ Uyarılar

- ⚡ Yüksek voltaj ve güç ile çalışıyorsanız elektrik güvenliğine dikkat edin
- 🔥 Isıtıcı sistemleri yangın riski taşır - gözetimsiz bırakmayın
- 🌡️ Maksimum sıcaklık sınırlarını ekipmanınıza göre ayarlayın
- 🧯 Yanıcı malzemelerin yakınında kullanmayın

## 👨‍💻 Geliştirme Notları

Sistem modüler olarak tasarlanmıştır. Her fonksiyon ayrı dosyalarda organize edilmiştir:
- Kolay bakım ve güncelleme
- Test edilebilir kod yapısı
- Yeni sensör veya çıkış eklemek kolay

---

**Geliştirici**: Oktay
**Tarih**: 2026
**Platform**: Arduino (ATmega328P)
**Dil**: C++

---

📧 Sorularınız için Issue açabilir veya katkıda bulunabilirsiniz!
