# Tarımın Dijital Pazarı

Modern ve kullanıcı dostu bir tarım ürünleri alım-satım platformu.

## 🚀 Versiyon 0.0.8

### ✅ Tamamlanan Özellikler

#### Pazar Sayfası İyileştirmeleri
- Modern ve akıcı kullanıcı arayüzü tasarımı
- Gelişmiş kaydırma davranışı ile optimize edilmiş ekran kullanımı
  - Sabit başlık çubuğu
  - Kaydırılabilir banner ve arama bölümü
  - Sabit kategori filtreleri
- Gelişmiş filtreleme sistemi
  - Kategori bazlı filtreleme
  - Fiyat aralığı filtresi
  - Miktar aralığı filtresi
  - İlan tipi filtresi (Satılık/Aranıyor)
  - Konum bazlı filtreleme
  - Organik ürün filtresi
  - Sertifikalı ürün filtresi
- Arama özelliği (başlık ve açıklamada)
- Aktif filtreler gösterimi ve kolay kaldırma
- Alt navigasyon menüsü
  - Pazar
  - Borsa
  - İlan Ekle
  - Mesajlar
  - Ayarlar

#### Teknik İyileştirmeler
- MVVM mimarisi implementasyonu
- Riverpod ile state management
- Firebase entegrasyonu
  - Authentication
  - Cloud Firestore
  - Storage
- Modern UI bileşenleri ve animasyonlar

### 📝 Yapılacaklar

#### Kısa Vadeli
- [ ] İlan detay sayfası tasarımı
- [ ] İlan ekleme formunun geliştirilmesi
- [ ] Mesajlaşma sisteminin implementasyonu
- [ ] Borsa sayfasının geliştirilmesi
- [ ] Profil sayfası tasarımı

#### Orta Vadeli
- [ ] Bildirim sistemi
- [ ] Favori ilanlar özelliği
- [ ] İlan paylaşma özelliği
- [ ] Konum bazlı öneriler
- [ ] Fiyat takip sistemi

#### Uzun Vadeli
- [ ] Çoklu dil desteği
- [ ] Tema özelleştirme
- [ ] Offline kullanım desteği
- [ ] Analitik dashboard
- [ ] Gelişmiş arama filtreleri

## 🛠️ Teknik Detaylar

### Kullanılan Teknolojiler
- Flutter
- Dart
- Firebase
- Riverpod
- Go Router
- Freezed

### Mimari
- MVVM (Model-View-ViewModel)
- Clean Architecture prensipleri
- Repository pattern

## 📦 Kurulum

```bash
# Bağımlılıkları yükle
flutter pub get

# Gerekli kod üretimini yap
flutter pub run build_runner build --delete-conflicting-outputs

# Uygulamayı çalıştır
flutter run
```

## 🤝 Katkıda Bulunma
1. Bu repository'yi fork edin
2. Feature branch'i oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun
