import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cdg_karaoke_player/service/client/interceptors/api_key_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class AbstractClient extends DioForNative {
  AbstractClient({this.isEnableEncrypt = false, this.apiKey}) : super() {
    if (isEnableEncrypt && apiKey == null) {
      throw 'Encryption requires api key.';
    }
    options = getBaseOptions();
    _certificatesConfigure();
    interceptors.addAll(
      _getInterceptors().whereType(),
    );
  }

  final bool isEnableEncrypt;
  final String? apiKey;

  BaseOptions getBaseOptions();

  void _certificatesConfigure() {
    httpClientAdapter = Http2Adapter(ConnectionManager(onClientCreate: (uri, config) => config.context = SecurityContext(withTrustedRoots: false)));
  }

  Future<Uint8List> getFileFromByteData(String certificatePem) async {
    final certificatePemByteData = await loadCertificate(certificatePem);
    final certificatePemData = certificatePemByteData.buffer.asUint8List(certificatePemByteData.offsetInBytes, certificatePemByteData.lengthInBytes);
    return certificatePemData;
  }

  ///
  /// If necessary, convert the certificate using the guide below:
  ///
  /// https://www.poftut.com/convert-der-pem-pem-der-certificate-format-openssl/
  ///
  Future<ByteData> loadCertificate(String certificate) => rootBundle.load(certificate);

  List<Interceptor?> _getInterceptors() => [
        loggerInterceptor,
        if (apiKey != null) ApiKeyInterceptor(apiKey ?? ''),
        ...additionalInterceptors,
      ];

  List<Interceptor?> get additionalInterceptors => [];

  Interceptor get loggerInterceptor => PrettyDioLogger(
        error: kDebugMode,
        request: kDebugMode,
        responseBody: kDebugMode,
        compact: kDebugMode,
      );
}
