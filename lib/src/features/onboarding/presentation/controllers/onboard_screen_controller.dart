import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OnboardScreenController extends GetxController {
  late PageController pageController;

  RxInt currentPage = 0.obs;
  final int totalSteps = 3;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void goNextContent() {
    if (currentPage < totalSteps - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
