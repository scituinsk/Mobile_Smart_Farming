import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  final String _md = '''
Dengan mengakses dan menggunakan fitur "Irigasi Cerdas" Fitur dalam aplikasi ini, Anda ("Pengguna") dianggap telah membaca, memahami, dan menyetujui seluruh isi dari syarat dan ketentuan di bawah ini.

## 1. Deskripsi Layanan

Fitur "Irigasi Cerdas" adalah sebuah sistem bantu digital yang dirancang untuk memudahkan Pengguna dalam:

* Memantau data kondisi lahan secara real-time, termasuk data suhu dan kelembapan, yang diterima dari perangkat sensor milik Pengguna.
* Mengontrol dan mengatur jadwal penyiraman, termasuk durasi dan frekuensi, dari jarak jauh melalui aplikasi.

Tujuan Fitur ini adalah sebagai alat pendukung dalam upaya menuju pertanian modern yang lebih efisien.

## 2. Ketergantungan pada Perangkat Keras dan Data

* **Akurasi Data:** Fungsi pemantauan real-time ("Pantau suhu, kelembapan, dan air") sepenuhnya bergantung pada akurasi, kalibrasi, dan kondisi operasional perangkat sensor yang dipasang di lahan oleh Pengguna. Kami tidak bertanggung jawab atas ketidakakuratan data yang disebabkan oleh malfungsi, penempatan yang salah, atau kerusakan sensor.
* **Eksekusi Perintah:** Kemampuan Fitur untuk menjalankan kontrol penyiraman ("Kontrol penyiraman jadi simpel banget") bergantung pada konektivitas internet yang stabil dan fungsi normal dari perangkat aktuator (misalnya, katup solenoid atau pompa air) di lahan Pengguna.

## 3. Tanggung Jawab Pengguna

Pengguna bertanggung jawab penuh atas:

* Pemasangan, perawatan, dan fungsionalitas semua perangkat keras yang terhubung ke sistem.
* Pengaturan awal dan penyesuaian jadwal penyiraman ("Atur durasi dan frekuensi").
* Pengguna memahami bahwa sistem hanya menjalankan perintah sesuai dengan konfigurasi yang dimasukkan oleh Pengguna.
''';

  @override
  Widget build(BuildContext context) {
    final double mediaQueryWidth = Get.width;
    final double mediaQueryHeight = Get.height;
    return Scaffold(
      appBar: AppBar(
        leading: Center(child: MyBackButton()),
        leadingWidth: 100,
        title: Text("Syarat & ketentuan", style: AppTheme.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
          child: Markdown(
            data: _md,
            selectable: false,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                .copyWith(
                  p: AppTheme.text,
                  h2: AppTheme.h4.copyWith(color: AppTheme.primaryColor),
                  listBullet: AppTheme.text,
                  blockSpacing: 12.h,
                ),
          ),
        ),
      ),
    );
  }
}
