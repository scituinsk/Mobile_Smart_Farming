import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/utils/custom_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoItemWidget extends StatelessWidget {
  final String text;
  final MyCustomIcon? customIcon;
  final String? imageAsset;
  final String? url;
  const ContactInfoItemWidget({
    super.key,
    required this.text,
    this.customIcon,
    this.imageAsset,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: url != null ? () async => await _launchURL(url!) : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        child: Row(
          spacing: 10.w,
          children: [
            if (customIcon != null) CustomIcon(type: customIcon!, size: 30),
            if (imageAsset != null)
              Image.asset(imageAsset!, width: 30.w, height: 30.h),
            Text(text),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    // if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    // } else {
    // LogUtils.d("could't launch url: $uri");
    // }
  }
}
