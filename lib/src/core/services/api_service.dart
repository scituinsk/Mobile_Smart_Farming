import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storage = Get.find<StorageService>();

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await _initializeDio();
  }

  Future<void> _initializeDio() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://smartfarmingapi.teknohole.com/api",
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),

        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        responseType: ResponseType.json,

        followRedirects: true,
        maxRedirects: 3,
      ),
    );
    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.readSecure('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        onResponse: (response, handler) {
          handler.next(response);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized();
          } else if (error.response?.statusCode == 403) {
            _handleForbidden();
          } else if (error.response!.statusCode! >= 500) {
            _handleServerError();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _handleUnauthorized() async {
    await _storage.deleteSecure('access_token');
    await _storage.deleteSecure('refresh_token');

    //notify authcontroller
    try {
      // final authController = Get.find<AuthController>();
      //logout
    } catch (e) {
      Get.offAllNamed(RouteNamed.loginPage);
    }
  }

  void _handleForbidden() {
    Get.snackbar(
      'Akses Ditolak',
      'Kamu tidak punya izin untuk mengakses resource',
    );
  }

  void _handleServerError() {
    Get.snackbar(
      'Server Error',
      'Sesuatu bermasalah di server. Silahkan coba lagi nanti.',
    );
  }

  //http method
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Future<Response> uploadFile(
    String path,
    String filePath, {
    dynamic fieldName = 'file',
    Map<String, dynamic>? data,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });
      return await _dio.post(path, data: formData);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception(
          'Waktu koneksi habis. Silakan periksa koneksi internet Anda.',
        );
      case DioExceptionType.sendTimeout:
        return Exception('Waktu permintaan habis. Silakan coba lagi.');
      case DioExceptionType.receiveTimeout:
        return Exception('Waktu respons habis. Silakan coba lagi.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ??
            'Terjadi kesalahan yang tidak diketahui';
        return Exception('Kesalahan server ($statusCode): $message');
      case DioExceptionType.cancel:
        return Exception('Permintaan dibatalkan');
      case DioExceptionType.connectionError:
        return Exception(
          'Kesalahan koneksi. Silakan periksa koneksi internet Anda.',
        );
      default:
        return Exception('Kesalahan tidak terduga: ${error.message}');
    }
  }
}
