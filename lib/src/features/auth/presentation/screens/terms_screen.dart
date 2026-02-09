import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';
import 'package:pak_tani/src/core/widgets/my_back_button.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double mediaQueryWidth = Get.width;
    final double mediaQueryHeight = Get.height;
    return Scaffold(
      appBar: AppBar(
        leading: Center(child: MyBackButton()),
        leadingWidth: 100,
        title: Text("auth_terms_title".tr, style: AppTheme.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: mediaQueryWidth,
          height: mediaQueryHeight,
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
          child: Markdown(
            data: "auth_terms_content".tr,
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
