import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/errors/api_exception.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/connectivity_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storage = Get.find<StorageService>();
  final ConnectivityService _connectivity = Get.find<ConnectivityService>();

  //  Better refresh tracking
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;
  final Set<String> _pendingRequests = <String>{}; // Track pending requests

  @override
  void onInit() async {
    super.onInit();
    await _initializeDio();
  }

  Future<void> _initializeDio() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: AppConfig.timeout),
        receiveTimeout: Duration(seconds: AppConfig.timeout),
        sendTimeout: Duration(seconds: AppConfig.timeout),
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
          if (!_connectivity.isConnected.value) {
            print("🚫 No interntet connection,  request to: ${options.path}");

            return handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
                error: NetworkException(
                  message:
                      "Tidak ada koneksi internet. Silahkan periksa jaringan anda",
                ),
              ),
            );
          }

          final requestId = '${options.method}-${options.path}';

          // ✅ Prevent duplicate requests
          if (_pendingRequests.contains(requestId)) {
            print('🚫 Duplicate request blocked: $requestId');
            handler.reject(
              DioException(
                requestOptions: options,
                message: 'Duplicate request blocked',
              ),
            );
            return;
          }

          _pendingRequests.add(requestId);
          print('📡 Request: ${options.method} ${options.path}');

          if (!_isAuthEndpoint(options.path)) {
            final accessToken = await _storage.readSecure('access_token');
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
              print('✅ Added token to: ${options.path}');
              print("Access token: $accessToken");
            } else {
              print('❌ No token for: ${options.path}');

              // ✅ If no token and not auth endpoint, reject immediately
              _pendingRequests.remove(requestId);
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 401,
                    statusMessage: 'No access token',
                  ),
                ),
              );
              return;
            }
          } else {
            print('🔐 Auth endpoint (no token): ${options.path}');
          }

          handler.next(options);
        },

        onResponse: (response, handler) {
          final requestId =
              '${response.requestOptions.method}-${response.requestOptions.path}';
          _pendingRequests.remove(requestId);

          print(
            '✅ Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          handler.next(response);
        },

        onError: (error, handler) async {
          final requestId =
              '${error.requestOptions.method}-${error.requestOptions.path}';
          _pendingRequests.remove(requestId);

          final statusCode = error.response?.statusCode;
          final path = error.requestOptions.path;
          final message = error.response?.statusMessage ?? error.message;

          print('❌ Error: $statusCode $path');
          print('❌ message: $message');

          // ✅ Handle 401 with better logic
          if (statusCode == 401 && !_isAuthEndpoint(path)) {
            print('🔄 Handling 401 for non-auth endpoint: $path');

            // ✅ Wait for ongoing refresh or start new one
            bool refreshSuccess = false;

            if (_isRefreshing && _refreshCompleter != null) {
              print('⏳ Waiting for ongoing refresh...');
              refreshSuccess = await _refreshCompleter!.future;
            } else {
              print('🔄 Starting new token refresh...');
              refreshSuccess = await _performTokenRefresh();
            }

            if (refreshSuccess) {
              print('✅ Token refreshed, retrying: $path');

              // ✅ Retry original request with new token
              final newAccessToken = await _storage.readSecure('access_token');
              if (newAccessToken != null) {
                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';

                try {
                  final response = await _dio.fetch(error.requestOptions);
                  return handler.resolve(response);
                } catch (retryError) {
                  print('❌ Retry failed: $retryError');
                  return handler.next(error);
                }
              }
            } else {
              print('❌ Token refresh failed, logging out...');
              await _handleLogout();
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  // ✅ Improved token refresh with Completer
  Future<bool> _performTokenRefresh() async {
    if (_isRefreshing && _refreshCompleter != null) {
      return await _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      print('🔄 Getting refresh token...');
      final refreshToken = await _storage.readSecure('refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        print('❌ No refresh token found');
        _refreshCompleter!.complete(false);
        return false;
      }

      print('🔄 Refresh token found, calling refresh API...');

      // ✅ Create separate Dio instance to avoid interceptor loops
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        '/token/refresh',
        data: {'refresh': refreshToken},
      );

      print('✅ Refresh API response: ${response.statusCode}');

      final newAccessToken = response.data['access'];

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await _storage.writeSecure('access_token', newAccessToken);

        // Update refresh token if provided
        final newRefreshToken = response.data['refresh'];
        if (newRefreshToken != null) {
          await _storage.writeSecure('refresh_token', newRefreshToken);
        }

        print('✅ Tokens updated successfully');
        _refreshCompleter!.complete(true);
        return true;
      } else {
        print('❌ No access token in refresh response');
        _refreshCompleter!.complete(false);
        return false;
      }
    } catch (e) {
      print('❌ Token refresh failed: $e');
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  bool _isAuthEndpoint(String path) {
    final authEndpoints = ['/login', '/register', '/logout', '/token/refresh'];
    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }

  Future<void> _handleLogout() async {
    try {
      print('🔄 Handling auto logout...');

      // ✅ Clear pending requests
      _pendingRequests.clear();
      _isRefreshing = false;
      _refreshCompleter = null;

      // ✅ Clear tokens
      await _storage.deleteSecure('access_token');
      await _storage.deleteSecure('refresh_token');

      // ✅ Call AuthService if available
      if (Get.isRegistered<AuthService>()) {
        final authService = Get.find<AuthService>();
        await authService.logout();
      }
    } catch (e) {
      print('❌ Logout error: $e');
    } finally {
      // ✅ Navigate to login
      if (Get.currentRoute != RouteNames.loginPage) {
        Get.offAllNamed(RouteNames.loginPage);
      }
    }
  }

  // ✅ Add request debouncing helper
  Future<T> _executeRequest<T>(
    String method,
    String path,
    Future<T> Function() request,
  ) async {
    final requestId = '$method-$path';

    // ✅ Check if similar request is already pending
    if (_pendingRequests.contains(requestId)) {
      throw NetworkException(message: 'Request already in progress');
    }

    try {
      return await request();
    } finally {
      _pendingRequests.remove(requestId);
    }
  }

  // ✅ Updated HTTP methods with debouncing
  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _executeRequest('GET', path, () async {
      try {
        return await _dio.get(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
        );
      } on DioException catch (error) {
        throw _handleDioError(error);
      }
    });
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _executeRequest('POST', path, () async {
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
    });
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

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
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

  // ✅ Rest of error handling methods stay the same...
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
    if (responseData is! Map<String, dynamic>) return responseData.toString();

    final data = responseData;
    final priorityFields = ['errors', 'message', 'detail', 'error'];

    for (final field in priorityFields) {
      if (data.containsKey(field) && data[field] != null) {
        final value = data[field];
        if (value is String && value.isNotEmpty) return value;
        if (value is Map) {
          final messages = <String>[];
          value.forEach((key, val) {
            if (val is List) {
              messages.addAll(val.map((e) => e.toString()));
            } else if (val != null) {
              messages.add(val.toString());
            }
          });
          if (messages.isNotEmpty) return messages.join(', ');
        }
        if (value is List && value.isNotEmpty) {
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
