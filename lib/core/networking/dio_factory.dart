import 'package:dio/dio.dart';
import 'package:doctor_app/core/networking/dio_interceptors.dart';
import 'package:doctor_app/core/networking/end_points.dart';

class DioFactory {
  Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    final dioInterceptors = DioInterceptors(dio);

    dio.interceptors.addAll([
      dioInterceptors.authInterceptor(),
      dioInterceptors.languageInterceptor(),
      dioInterceptors.debugeDioLogger(),
    ]);

    return dio;
  }
}
