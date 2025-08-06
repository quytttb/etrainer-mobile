import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'hive_service.dart';

class ApiService {
  late final Dio _dio;
  final HiveService _hiveService;

  ApiService(this._hiveService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: ApiConstants.defaultHeaders,
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _hiveService.getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle token refresh on 401
          if (error.response?.statusCode == 401) {
            final refreshToken = _hiveService.getRefreshToken();
            if (refreshToken != null) {
              try {
                final newToken = await _refreshToken(refreshToken);
                if (newToken != null) {
                  // Retry original request with new token
                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newToken';
                  final response = await _dio.fetch(options);
                  return handler.resolve(response);
                }
              } catch (e) {
                // Refresh failed, clear tokens and redirect to login
                await _hiveService.clearAuthData();
              }
            }
          }
          handler.next(error);
        },
      ),
    );

    // Retry Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            try {
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } catch (e) {
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );

    // Logging Interceptor (Debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  Future<String?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

        await _hiveService.saveAuthTokens(newToken, newRefreshToken);
        return newToken;
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
    return null;
  }

  // GET Request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // POST Request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // PUT Request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // DELETE Request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // PATCH Request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Upload File
  Future<Response<T>> uploadFile<T>(
    String path,
    String filePath, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        fieldName: await MultipartFile.fromFile(filePath),
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  void dispose() {
    _dio.close();
  }
}

// Custom API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ApiException(this.message, {this.statusCode, this.errorCode});

  factory ApiException.fromDioException(DioException dioException) {
    String message;
    int? statusCode;
    String? errorCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = AppConstants.networkErrorMessage;
        break;
      case DioExceptionType.badResponse:
        statusCode = dioException.response?.statusCode;
        message = _getErrorMessage(dioException.response?.data);
        errorCode = _getErrorCode(dioException.response?.data);
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = AppConstants.networkErrorMessage;
        break;
      case DioExceptionType.unknown:
      default:
        message = AppConstants.unknownErrorMessage;
        break;
    }

    return ApiException(message, statusCode: statusCode, errorCode: errorCode);
  }

  static String _getErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] ?? 
             responseData['error'] ?? 
             AppConstants.serverErrorMessage;
    }
    return AppConstants.serverErrorMessage;
  }

  static String? _getErrorCode(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['code'] ?? responseData['errorCode'];
    }
    return null;
  }

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Code: $errorCode)';
  }
}
