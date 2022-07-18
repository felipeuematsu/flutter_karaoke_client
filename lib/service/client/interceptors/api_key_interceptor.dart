import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiKeyInterceptor extends Interceptor {

  ApiKeyInterceptor(this.apiKey);

  final String apiKey;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    final logger = Logger();
    if (apiKey.isEmpty) {
      logger.e('Api key is empty');
    }
    options.headers['apiKey'] = apiKey;

    super.onRequest(options, handler);
  }

}