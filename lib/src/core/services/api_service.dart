/// Service for all API.
/// Handle all http request.
/// Using dio library to handle all http request including error handling, token management, retry request, etc.

library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:pak_tani/src/core/config/app_config.dart';
import 'package:pak_tani/src/core/errors/api_exception.dart';
import 'package:pak_tani/src/core/routes/route_named.dart';
import 'package:pak_tani/src/core/services/connectivity_service.dart';
import 'package:pak_tani/src/core/services/storage_service.dart';
import 'package:pak_tani/src/features/auth/application/services/auth_services.dart';

///Service class for API service.
class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storage = Get.find<StorageService>();
  final ConnectivityService _connectivity = Get.find<ConnectivityService>();

  //  Better refresh tracking
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;
  final Set<String> _pendingRequests = <String>{};

  final Completer<void> _dioCompleter = Completer<void>();
  Future<void> get isReady => _dioCompleter.future;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
  }

  /// Initializes Dio settings.
  /// this include base options and add inteceptor
  void _initializeDio() {
    _dio = Dio(
      // base options is base setting for request, like request base url, timeout, global headers, response type, etc.
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
    _dioCompleter.complete();
  }

  /// Add inteceptor for dio.
  /// Interceptor is used for block, modify, or handle http request, response, error automatically
  /// before of after this request processed by dio.
  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        // before do request, check internet connection, check is this request duplicated
        // then check is the endpoint is auth endpoint, this prevent auth endpoint being rejected.
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

          final isFormData = options.data is FormData;
          final dataString = isFormData
              ? 'form-data-${DateTime.now().millisecondsSinceEpoch}'
              : options.data.toString();

          final requestId =
              '${options.method}-${options.path}-${options.queryParameters}-$dataString';
          //  Prevent duplicate requests
          // if pending request contains this request id, reject this request
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

          // add this request id to pending request
          // so the request won't duplicated
          _pendingRequests.add(requestId);

          /// store request id into extra
          options.extra["request_id"] = requestId;
          print('📡 Request: ${options.method} ${options.path}');

          if (!_isAuthEndpoint(options.path)) {
            final accessToken = await _storage.readSecure('access_token');
            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
              print('✅ Added token to: ${options.path}');
            } else {
              print('❌ No token for: ${options.path}');

              // If no token and not auth endpoint, reject immediately
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

        // while do request, print status code and path for debug necessity.
        onResponse: (response, handler) {
          final requestId = response.requestOptions.extra["request_id"];
          if (requestId != null) {
            _pendingRequests.remove(requestId);
          }

          print(
            '✅ Response: ${response.statusCode} ${response.requestOptions.path}',
          );
          handler.next(response);
        },

        // if response error, check if error is 401 and not auth endpoint then do refresh token
        // then retry request with new access token
        onError: (error, handler) async {
          final requestId = error.requestOptions.extra["request_id"];
          if (requestId != null) {
            _pendingRequests.remove(requestId);
          }

          final statusCode = error.response?.statusCode;
          final path = error.requestOptions.path;
          final message = error.response?.statusMessage ?? error.message;

          print('❌ Error: $statusCode $path');
          print('❌ message: $message');

          // ✅ Handle 401 with better logic
          if (statusCode == 401 && !_isAuthEndpoint(path)) {
            if (error.response?.data["data"] != "unauthorized") {
              print('🔄 Handling 401 for non-auth endpoint: $path');

              // Wait for ongoing refresh or start new one
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

                // Retry original request with new token
                final newAccessToken = await _storage.readSecure(
                  'access_token',
                );
                if (newAccessToken != null) {
                  // Create new options to avoid FromData finalization issues
                  final newOptions = error.requestOptions.copyWith(
                    headers: {
                      ...error.requestOptions.headers,
                      'Authorization': 'Bearer $newAccessToken',
                    },
                  );

                  // If data is FormData, recreate it to avoid finalization
                  if (error.requestOptions.data is FormData) {
                    final originalFormData =
                        error.requestOptions.data as FormData;
                    final newFormData = FormData();
                    for (var entry in originalFormData.fields) {
                      newFormData.fields.add(entry);
                    }
                    for (var file in originalFormData.files) {
                      newFormData.files.add(file);
                    }
                    newOptions.data = newFormData;
                  }

                  // Retry with new options
                  try {
                    final response = await _dio.fetch(newOptions);
                    return handler.resolve(response);
                  } catch (retryError) {
                    print('❌ Retry failed: $retryError');

                    if (retryError is DioException) {
                      return handler.next(error);
                    }
                    return handler.next(error);
                  }
                }
              } else {
                // if token refresh with refreh token failed, then do log out.
                print('❌ Token refresh failed, logging out...');
                await _handleLogout();
              }
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  /// Refresh access token.
  /// Send request to refresh token, this will keep the new access token and refresh token and return [bool].
  Future<bool> _performTokenRefresh() async {
    if (_isRefreshing && _refreshCompleter != null) {
      return await _refreshCompleter!.future;
    }

    _isRefreshing = true;

    // completer is used for create future object manually
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

      // Create separate Dio instance to avoid interceptor loops
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

        final newRefreshToken = response.data['refresh'];
        await _storage.writeSecure('refresh_token', newRefreshToken);

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

  /// Checking is this path is auth endpoint or not.
  /// It will return [bool]
  bool _isAuthEndpoint(String path) {
    final authEndpoints = ['/login', '/register', '/logout', '/token/refresh'];
    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }

  /// Handle logout.
  /// Clear all pending request, access and refresh token
  Future<void> _handleLogout() async {
    try {
      print('🔄 Handling auto logout...');

      //  Clear pending requests
      _pendingRequests.clear();
      _isRefreshing = false;
      _refreshCompleter = null;

      //  Clear tokens
      await _storage.deleteSecure('access_token');
      await _storage.deleteSecure('refresh_token');

      // Call AuthService if available
      if (Get.isRegistered<AuthService>()) {
        final authService = Get.find<AuthService>();
        await authService.logout();
      }
    } catch (e) {
      print('❌ Logout error: $e');
    } finally {
      //  Navigate to login
      if (Get.currentRoute != RouteNames.loginPage) {
        Get.offAllNamed(RouteNames.loginPage);
      }
    }
  }

  /// Http request Get.
  /// Handle custom get with dio.
  Future<Response> get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await isReady;
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
  }

  /// Http request post.
  /// Handle custom post with dio.
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await isReady;
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

  /// Http request Put.
  /// Handle custom Put with dio.
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await isReady;
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

  /// Http request Patch.
  /// Handle custom Patch with dio.
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await isReady;
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

  /// Http request Delete.
  /// Handle custom Delete with dio.
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await isReady;
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

  /// Http request post for file.
  /// Handle custom post file with dio.
  Future<Response> uploadFile(
    String path,
    String filePath, {
    dynamic fieldName = 'file',
    Map<String, dynamic>? data,
  }) async {
    try {
      await isReady;
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });
      return await _dio.post(path, data: formData);
    } on DioException catch (error) {
      throw _handleDioError(error);
    }
  }

  /// Keep the rest of error handling methods stay the same
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

  /// Extract error message with unpredicted structure to [String].
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

  /// Convert status code to message that can be used in screen.
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
