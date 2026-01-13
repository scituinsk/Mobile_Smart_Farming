import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';
import 'package:pak_tani/src/features/modul/domain/entities/modul.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends StatelessWidget {
  QrCodeScreen({super.key});

  final Modul modul = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: MyBackButton(),
          ),
        ),
        actionsPadding: EdgeInsets.only(right: 30.w),
        title: Text("QR Code", style: AppTheme.h3),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 25.w),
            child: Column(
              spacing: 25.r,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Silahkan Scan QR Code dibawah ini:",
                  textAlign: TextAlign.center,
                  style: AppTheme.h3.copyWith(color: AppTheme.primaryColor),
                ),
                QrImageView(data: modul.serialId, size: 220.r),
                Text(
                  'Orang yang memindai kode ini dengan aplikasi akan langsung mendapatkan akses untuk melihat data dari modul\n"${modul.name}"',
                  textAlign: TextAlign.center,
                  style: AppTheme.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
