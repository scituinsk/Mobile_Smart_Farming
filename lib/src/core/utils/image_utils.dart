import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pak_tani/src/core/theme/app_theme.dart';

/// Utility class for image picking and cropping operations.
/// Provides reusable methods for selecting and cropping images from camera or gallery.
class ImageUtils {
  /// Picks an image from the specified [source] (camera or gallery),
  /// displays a cropping UI with the given [aspectRatio], and returns the cropped image file.
  ///
  /// Shows a loading dialog during the process and handles errors gracefully.
  /// Returns null if the user cancels or an error occurs.
  ///
  /// Parameters:
  /// - [source]: The source of the image (ImageSource.camera or ImageSource.gallery).
  /// - [aspectRatio]: Optional aspect ratio for cropping (defaults to 590:390 if not provided).
  /// - [compressQuality]: Compression quality (0-100, defaults to 80).
  static Future<File?> pickAndCropImage(
    ImageSource source, {
    CropAspectRatio? aspectRatio,
    int compressQuality = 80,
  }) async {
    final ImagePicker picker = ImagePicker();
    final defaultAspectRatio =
        aspectRatio ?? const CropAspectRatio(ratioX: 590, ratioY: 390);

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
        barrierColor: Colors.black54,
        useSafeArea: false,
      );

      // Pick image
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (pickedFile == null) return null; // User canceled

      // Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: defaultAspectRatio,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Gambar",
            toolbarColor: AppTheme.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            hideBottomControls: false,
            aspectRatioPresets: [CropAspectRatioPreset.original],
          ),
        ],
        compressQuality: compressQuality,
      );

      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      // Handle errors (e.g., permissions denied, cropping failed)
      Get.snackbar(
        'Error',
        'Gagal memilih atau crop gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  /// Shows a bottom sheet for selecting image source (camera or gallery),
  /// then picks and crops the image using [pickAndCropImage].
  ///
  /// Returns the cropped image file or null if canceled/error.
  ///
  /// Parameters:
  /// - [context]: BuildContext for showing the bottom sheet.
  /// - [aspectRatio]: Optional aspect ratio for cropping.
  /// - [compressQuality]: Compression quality (0-100, defaults to 80).
  static Future<File?> showImageSourceAndPick(
    BuildContext context, {
    CropAspectRatio? aspectRatio,
    int compressQuality = 80,
  }) async {
    final completer = Completer<File?>();

    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Pilih Sumber Gambar', style: AppTheme.h4),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppTheme.primaryColor),
                title: Text('Kamera', style: AppTheme.text),
                onTap: () async {
                  Get.back(); // Close bottom sheet
                  final result = await pickAndCropImage(
                    ImageSource.camera,
                    aspectRatio: aspectRatio,
                    compressQuality: compressQuality,
                  );
                  completer.complete(result);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppTheme.primaryColor,
                ),
                title: Text('Galeri', style: AppTheme.text),
                onTap: () async {
                  Get.back(); // Close bottom sheet
                  final result = await pickAndCropImage(
                    ImageSource.gallery,
                    aspectRatio: aspectRatio,
                    compressQuality: compressQuality,
                  );
                  completer.complete(result);
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );

    return completer.future;
  }
}
