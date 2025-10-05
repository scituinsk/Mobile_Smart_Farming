import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog {
  static void show({
    required BuildContext context,
    required Widget title,
    required Widget child,
    double? widthTitle,
    double? height,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: height,
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
                margin: EdgeInsets.fromLTRB(20, 20, 20, 15),
                child: title,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
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
