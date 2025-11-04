import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required Widget title,
    required Widget child,
    double? widthTitle,
    double? widthChild,
    double? height,
    double dialogMargin = 5,
  }) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: dialogMargin,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: height,
          constraints: BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: widthTitle,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: title,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                width: widthChild,
                child: child,
              ),
            ],
          ),
        ),
      ),

      barrierDismissible: true,
    );
  }
}
