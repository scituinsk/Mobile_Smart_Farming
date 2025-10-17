import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddModulUiController extends GetxController {
  late TextEditingController modulCodeController;
  late TextEditingController modulPasswordController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    modulCodeController = TextEditingController();
    modulPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    modulCodeController.dispose();
    modulPasswordController.dispose();
    super.dispose();
  }
}
