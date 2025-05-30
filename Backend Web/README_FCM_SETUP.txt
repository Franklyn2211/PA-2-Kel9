# Langkah Selanjutnya Setelah Integrasi FCM Service Account

1. **Pastikan file JSON service account sudah disimpan**  
   Contoh:  
   `d:\semester 4\proyekku\PA-2-Kel9\Backend Web\storage\firebase\proyek-akhir2-67ee8-9e5e84f1db5a.json`

2. **Pastikan path file sudah ditulis di .env**  
   ```
   FCM_SERVICE_ACCOUNT_JSON=storage/firebase/proyek-akhir2-67ee8-9e5e84f1db5a.json
   ```

3. **Gunakan library PHP untuk FCM v1**  
   - Jika Anda mengalami error dependency saat install `kreait/firebase-php` atau `laravel-notification-channels/fcm`:
     - Pastikan versi PHP Anda kompatibel dengan library yang ingin diinstall (cek dokumentasi library).
     - Pastikan ekstensi PHP sodium sudah aktif (`ext-sodium`), cek di `php.ini` dan aktifkan jika perlu.
     - Jalankan `composer update --with-all-dependencies` sebelum mencoba install.
     - Jika tetap gagal, gunakan library PHP lain yang lebih sederhana untuk mengirim FCM v1, atau gunakan HTTP request manual dengan Guzzle/HTTP client.
   - Jika hanya ingin notifikasi lokal di mobile (tanpa push dari backend), **langkah ini bisa dilewati**.

4. **Pastikan aplikasi mobile sudah menerima token FCM dan mengirimkannya ke backend**  
   - Token FCM user harus disimpan di database (misal: kolom `fcm_token` pada tabel `residents`).

5. **Saat status pengajuan di-approve, backend kirim notifikasi ke FCM**  
   - Gunakan service account JSON untuk autentikasi.
   - Kirim notifikasi ke token user yang bersangkutan.

6. **Cek aplikasi mobile**  
   - Pastikan aplikasi sudah menerima notifikasi saat status pengajuan berubah/disetujui.

---

# Kapan fcm_token akan terisi?

- **fcm_token** akan terisi saat aplikasi mobile (Flutter) berhasil mendapatkan token FCM dari Firebase dan mengirimkannya ke backend melalui API `/user/save-fcm-token`.
- Proses ini biasanya dilakukan **setelah user login** atau **saat aplikasi pertama kali dijalankan** (dan user sudah login).
- Di sisi mobile, setelah mendapatkan token FCM (misal dengan `FirebaseMessaging.instance.getToken()`), aplikasi harus memanggil endpoint `/user/save-fcm-token` dan mengirimkan `user_id` serta `fcm_token`.
- Setelah API ini dipanggil, backend akan menyimpan token tersebut di kolom `fcm_token` pada tabel `residents`.

**Singkatnya:**
- fcm_token akan terisi setelah aplikasi mobile mengirim token FCM user ke backend, biasanya setelah login atau saat token FCM berubah.

---

# Checklist Konfigurasi Firebase Flutter

Jika aplikasi hanya menampilkan icon Flutter (stuck di splash screen), kemungkinan besar ada masalah pada konfigurasi Firebase. Berikut yang perlu dicek:

1. **File google-services.json (Android)**
   - Pastikan file `google-services.json` sudah diunduh dari Firebase Console.
   - Letakkan file tersebut di:  
     `android/app/google-services.json`

2. **File GoogleService-Info.plist (iOS)**
   - Jika build untuk iOS, pastikan file `GoogleService-Info.plist` ada di:  
     `ios/Runner/GoogleService-Info.plist`

3. **android/build.gradle**
   - Tambahkan di `buildscript > dependencies`:
     ```
     classpath 'com.google.gms:google-services:4.3.15'
     ```
   - Tambahkan di `buildscript > repositories` jika belum ada:
     ```
     google()
     ```

4. **android/app/build.gradle**
   - Tambahkan di paling bawah file:
     ```
     apply plugin: 'com.google.gms.google-services'
     ```

5. **firebase_core & firebase_messaging**
   - Pastikan sudah menambahkan dependency di `pubspec.yaml`:
     ```yaml
     firebase_core: ^2.0.0
     firebase_messaging: ^14.0.0
     ```
   - Sudah menjalankan `flutter pub get`.

6. **Internet Permission (Android)**
   - Di `android/app/src/main/AndroidManifest.xml`, pastikan ada:
     ```xml
     <uses-permission android:name="android.permission.INTERNET"/>
     ```

7. **Proguard (jika release build)**
   - Jika menggunakan proguard, cek dokumentasi firebase untuk rule yang perlu ditambahkan.

8. **Rebuild Project**
   - Jalankan:
     ```
     flutter clean
     flutter pub get
     flutter run
     ```

9. **Cek Log Error**
   - Jalankan aplikasi dengan `flutter run` di terminal dan lihat error detail di log.

---

**Jika semua sudah benar, aplikasi akan bisa melewati splash screen dan Firebase akan terinisialisasi dengan baik.  
Jika masih stuck, cek log error di terminal untuk detail masalahnya.**

---

**Jika semua langkah di atas sudah dilakukan, sistem notifikasi push sudah aktif.  
Jika ingin contoh kode PHP untuk FCM v1, sebutkan library yang ingin digunakan.**

# Penjelasan: Notifikasi FCM yang Muncul di Mobile

Jika token FCM sudah berhasil masuk ke database, maka:
- Saat admin menyetujui pengajuan (status jadi "disetujui"), backend akan mengirim **push notification** ke device user menggunakan token FCM tersebut.

## Bentuk Notifikasi yang Muncul

- **Notifikasi push** akan muncul di status bar/notification tray HP Android/iOS, seperti notifikasi WhatsApp, Shopee, dll.
- Isi notifikasi sesuai yang dikirim backend, misal:
  - Judul: `Pengajuan Surat Disetujui`
  - Pesan: `Pengajuan surat Anda telah disetujui oleh admin.`

## Syarat Notifikasi Muncul

1. **Aplikasi mobile sudah terinstall dan pernah mendapatkan token FCM.**
2. **Aplikasi tidak harus dalam keadaan terbuka** (bisa background atau bahkan tertutup).
3. **Backend benar-benar mengirim request ke FCM** saat status berubah (lihat log Laravel, cek response FCM).

## Debugging Jika Notifikasi Tidak Muncul

- **Cek log backend**: Apakah ada error saat mengirim ke FCM? (lihat `storage/logs/laravel.log`)
- **Cek response FCM**: Apakah sukses (`"success":1`) atau error?
- **Cek device**: Apakah notifikasi dari aplikasi lain (misal WhatsApp) muncul? Jika tidak, cek pengaturan notifikasi HP.
- **Cek kode Flutter**: Pastikan tidak ada filter/handler yang menahan notifikasi di sisi mobile.

## Contoh Notifikasi yang Dikirim Backend (Laravel)

```php
$this->sendFcmNotification(
    $resident->fcm_token,
    'Pengajuan Surat Disetujui',
    'Pengajuan surat Anda telah disetujui oleh admin.'
);
```

## Contoh Notifikasi yang Muncul di HP

- **Judul:** Pengajuan Surat Disetujui
- **Isi:** Pengajuan surat Anda telah disetujui oleh admin.

---

**Catatan:**  
Jika ingin menampilkan notifikasi custom di dalam aplikasi (misal dialog pop-up), tambahkan handler di Flutter menggunakan `FirebaseMessaging.onMessage.listen(...)`.  
Namun, notifikasi push standar akan otomatis muncul di notification tray HP jika payload `notification` dikirim dari backend.

---

**Jika notifikasi belum muncul:**
- Cek log backend (apakah FCM response sukses)
- Cek pengaturan notifikasi HP
- Cek apakah token FCM benar dan sesuai device
- Cek apakah aplikasi sudah pernah dijalankan di device tersebut

Jika ingin contoh kode handler notifikasi di Flutter, silakan minta.
