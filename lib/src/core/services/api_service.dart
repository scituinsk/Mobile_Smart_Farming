import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pak_tani/src/core/errors/api_exception.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storage = Get.find<StorageService>();

  // ✅ Add refresh tracking to prevent loops
  bool _isRefreshing = false;
  final List<RequestOptions> _requestsNeedingRefresh = [];

  @override
  Future<void> onInit() async {
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
          // ✅ Add logging to debug
          print('📡 Request: ${options.method} ${options.path}');

          if (!_isAuthEndpoint(options.path)) {
            final accessToken = await _storage.readSecure('access_token');
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
              print('🔑 Added token to: ${options.path}');
            } else {
              print('❌ No token for: ${options.path}');
            }
          } else {
            print('🔓 Auth endpoint (no token): ${options.path}');
          }

          handler.next(options);
        },

        onResponse: (response, handler) {
          print(
            '✅ Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          handler.next(response);
        },

        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final path = error.requestOptions.path;

          print('❌ Error: ${statusCode} ${path}');

          // ✅ Handle 401 with proper loop prevention
          if (statusCode == 401 && !_isAuthEndpoint(path)) {
            print('🔄 Handling 401 for non-auth endpoint: $path');

            // ✅ Prevent multiple concurrent refresh attempts
            if (_isRefreshing) {
              print('⏳ Already refreshing, queuing request: $path');
              _requestsNeedingRefresh.add(error.requestOptions);
              return; // Don't resolve or reject yet
            }

            _isRefreshing = true;
            print('🔄 Starting token refresh...');

            try {
              final refreshSuccess = await _refreshAccessToken();

              if (refreshSuccess) {
                print('✅ Token refresh successful, retrying: $path');

                // ✅ Retry original request with new token
                final newAccessToken = await _storage.readSecure(
                  'access_token',
                );
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                final response = await _dio.fetch(error.requestOptions);

                // ✅ Process queued requests
                await _processQueuedRequests();

                return handler.resolve(response);
              } else {
                print('❌ Token refresh failed, logging out...');
                await _handleLogout();
                return handler.next(error);
              }
            } catch (e) {
              print('❌ Token refresh error: $e');
              await _handleLogout();
              return handler.next(error);
            } finally {
              _isRefreshing = false;
              _requestsNeedingRefresh.clear();
              print('🏁 Token refresh process completed');
            }
          }
          // ✅ Handle other errors
          else if (statusCode == 403) {
            _handleForbidden();
          } else if (statusCode != null && statusCode >= 500) {
            _handleServerError();
          }

          handler.next(error);
        },
      ),
    );
  }

  // ✅ Fixed: Check actual API endpoints
  bool _isAuthEndpoint(String path) {
    final authEndpoints = ['/login', '/register', '/logout', '/token/refresh'];

    final isAuth = authEndpoints.any((endpoint) => path.startsWith(endpoint));
    print('🔍 Is auth endpoint? $path -> $isAuth');
    return isAuth;
  }

  Future<bool> _refreshAccessToken() async {
    try {
      print('🔄 Getting refresh token...');
      final refreshToken = await _storage.readSecure('refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        print('❌ No refresh token found');
        return false;
      }

      print('🔑 Refresh token found, calling refresh API...');

      // ✅ Create separate Dio instance to avoid interceptor loops
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: "https://smartfarmingapi.teknohole.com/api",
          connectTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        '/token/refresh/', // ✅ Make sure endpoint is correct
        data: {'refresh': refreshToken},
      );

      print('✅ Refresh API response: ${response.statusCode}');
      print('📄 Refresh response data: ${response.data}');

      final newAccessToken = response.data['access'];

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await _storage.writeSecure('access_token', newAccessToken);

        // ✅ Update refresh token if provided
        final newRefreshToken = response.data['refresh'];
        if (newRefreshToken != null) {
          await _storage.writeSecure('refresh_token', newRefreshToken);
        }

        print('✅ Tokens updated successfully');
        return true;
      } else {
        print('❌ No access token in refresh response');
        return false;
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
      return false;
    }
  }

  // ✅ Process queued requests after successful refresh
  Future<void> _processQueuedRequests() async {
    if (_requestsNeedingRefresh.isEmpty) return;

    print('🔄 Processing ${_requestsNeedingRefresh.length} queued requests...');

    final newAccessToken = await _storage.readSecure('access_token');

    for (final request in _requestsNeedingRefresh) {
      try {
        request.headers['Authorization'] = 'Bearer $newAccessToken';
        await _dio.fetch(request);
        print('✅ Retried queued request: ${request.path}');
      } catch (e) {
        print('❌ Failed to retry queued request: ${request.path} - $e');
      }
    }
  }

  Future<void> _handleLogout() async {
    print('🔄 Handling auto logout...');

    await _storage.deleteSecure('access_token');
    await _storage.deleteSecure('refresh_token');

    try {
      // ✅ If you have AuthService, call it
      // final authService = Get.find<AuthService>();
      // authService.handleAutoLogout();
    } catch (e) {
      print('❌ AuthService not found during auto logout: $e');
    }

    Get.offAllNamed(RouteNamed.loginPage);
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

  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Koneksi timeout. Periksa internet Anda.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        print('API Error - Status Code: $statusCode');
        print('API Error - Response Data: $responseData');

        String message = _getStatusMessage(statusCode);

        if (responseData != null) {
          message = _extractErrorMessage(responseData);
        }

        return ServerException(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return NetworkException(message: 'Permintaan dibatalkan');

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Tidak dapat terhubung ke server. Periksa internet Anda.',
        );

      default:
        return NetworkException(
          message: 'Kesalahan jaringan: ${error.message}',
        );
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData is! Map<String, dynamic>) {
      return responseData.toString();
    }

    final data = responseData;
    final priorityFields = ['errors', 'message', 'detail', 'error'];

    for (final field in priorityFields) {
      if (data.containsKey(field) && data[field] != null) {
        final value = data[field];

        if (value is String && value.isNotEmpty) {
          return value;
        } else if (value is Map) {
          final messages = <String>[];
          value.forEach((key, val) {
            if (val is List) {
              messages.addAll(val.map((e) => e.toString()));
            } else if (val != null) {
              messages.add(val.toString());
            }
          });
          if (messages.isNotEmpty) return messages.join(', ');
        } else if (value is List && value.isNotEmpty) {
          return value.map((e) => e.toString()).join(', ');
        }
      }
    }

    return _getStatusMessage(null);
  }

  String _getStatusMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Data yang dikirim tidak valid';
      case 401:
        return 'Username atau password salah';
      case 403:
        return 'Akses tidak diizinkan';
      case 404:
        return 'Data tidak ditemukan';
      case 500:
        return 'Server sedang bermasalah';
      default:
        return 'Terjadi kesalahan pada server';
    }
  }
}
