import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/utils/image_utils.dart';
import 'package:pak_tani/src/core/utils/loading_dialog.dart';
import 'package:pak_tani/src/core/utils/my_snackbar.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';
import 'package:pak_tani/src/features/profile/application/services/profile_service.dart';
import 'package:pak_tani/src/features/profile/domain/entities/user.dart';

class ProfileController extends GetxController
    with GetTickerProviderStateMixin {
  final AuthService authService;
  final ProfileService profileService;
  ProfileController(this.authService, this.profileService);

  late TabController tabController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  // late TextEditingController usernameController;
  // late TextEditingController emailController;
  late GlobalKey<FormState> formKey;

  final RxBool isFormValid = false.obs;
  final RxBool hasChanges = false.obs;

  Rx<User?> get currentUser => profileService.currentUser;
  RxBool get isLoading => profileService.isLoading;
  RxBool get isLoadingSubmit => profileService.isLoadingSubmit;
  RxMap<String, dynamic> get contacts => profileService.contacts;

  Future<void> handleLogOut() async {
    LoadingDialog.show();
    try {
      await authService.logout();

      Get.offAllNamed(RouteNames.loginPage);
      MySnackbar.success(message: "Logout berhasil");
    } catch (e) {
      MySnackbar.error(message: e.toString());
    } finally {
      LoadingDialog.hide();
    }
  }

  void handleEditProfile() async {
    if (formKey.currentState!.validate()) {
      try {
        await profileService.editUserProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          // username: usernameController.text,
          // email: emailController.text,
        );

        MySnackbar.success(message: "Berhasil mengubah profile!");
      } catch (e) {
        print("error edit profile(controller): $e");
        MySnackbar.error(message: e.toString());
      }
    }
  }

  void handleEditPhotoProfile(BuildContext context) async {
    try {
      final pickedFile = await ImageUtils.showImageSourceAndPick(
        context,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (pickedFile != null) {
        await profileService.editUserProfile(imageFile: pickedFile);
        MySnackbar.success(message: "Berhasil mengubah photo profile");
      }
    } catch (e) {
      MySnackbar.error(message: e.toString());
    }
  }

  void refreshTextControllerAndFocusNode() {
    print("refreh and unfocus");
    if (currentUser.value != null) {
      firstNameController.text = currentUser.value!.firstName;
      lastNameController.text = currentUser.value!.lastName ?? "";
      // usernameController.text = currentUser.value!.username;
      // emailController.text = currentUser.value!.email;
    }
  }

  void _checkFormValidity() {
    final firstName = firstNameController.text.trim();
    // final username = usernameController.text.trim();
    // final email = emailController.text.trim();

    // isFormValid.value =
    //     firstName.isNotEmpty && username.isNotEmpty && email.isNotEmpty;

    isFormValid.value = firstName.isNotEmpty;

    _checkForChanges();
  }

  void _checkForChanges() {
    if (currentUser.value == null) {
      hasChanges.value = false;
      return;
    }

    final currentFirstName = currentUser.value!.firstName.trim();
    final currentLastName = (currentUser.value!.lastName ?? "").trim();
    // final currentUsername = currentUser.value!.username.trim();
    // final currentEmail = currentUser.value!.email.trim();

    final editedFirstName = firstNameController.text.trim();
    final editedLastName = lastNameController.text.trim();
    // final editedUsername = usernameController.text.trim();
    // final editedEmail = emailController.text.trim();

    hasChanges.value =
        editedFirstName != currentFirstName ||
        editedLastName != currentLastName;
    // || editedUsername != currentUsername ||
    // editedEmail != currentEmail;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama depan tidak boleh kosong';
    }
    if (value.trim().length < 2) {
      return 'Nama depan minimal 2 karakter';
    }
    if (value.trim().length > 255) {
      return "Nama depan maksimal 255 karakter";
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length > 255) {
      return "Nama belakang maksimal 255 karakter";
    }
    return null;
  }

  // String? validateUsername(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'Username tidak boleh kosong';
  //   }
  //   if (value.trim().length < 3) {
  //     return 'Username minimal 3 karakter';
  //   }
  //   if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
  //     return 'Username hanya boleh mengandung huruf, angka, dan underscore';
  //   }
  //   return null;
  // }

  // String? validateEmail(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'Email tidak boleh kosong';
  //   }
  //   if (!RegExp(
  //     r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  //   ).hasMatch(value.trim())) {
  //     return 'Format email tidak valid';
  //   }
  //   return null;
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    formKey = GlobalKey<FormState>();

    if (currentUser.value != null) {
      firstNameController = TextEditingController(
        text: currentUser.value!.firstName,
      );
      lastNameController = TextEditingController(
        text: currentUser.value!.lastName ?? "",
      );
      // usernameController = TextEditingController(
      //   text: currentUser.value!.username,
      // );
      // emailController = TextEditingController(text: currentUser.value!.email);
    }

    _checkFormValidity();

    firstNameController.addListener(_checkFormValidity);
    lastNameController.addListener(_checkForChanges);
    // usernameController.addListener(_checkFormValidity);
    // emailController.addListener(_checkFormValidity);
  }

  @override
  void onClose() {
    firstNameController.removeListener(_checkFormValidity);
    lastNameController.removeListener(_checkForChanges);
    // usernameController.removeListener(_checkFormValidity);
    // emailController.removeListener(_checkFormValidity);

    firstNameController.dispose();
    lastNameController.dispose();
    // usernameController.dispose();
    // emailController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
