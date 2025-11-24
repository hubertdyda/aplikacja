import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KlientApi {
  final Dio dio;

  KlientApi()
      : dio = Dio(
    BaseOptions(
      baseUrl: 'https://v3.football.api-sports.io',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'x-apisports-key': dotenv.env['API_FOOTBALL_KEY'],
        'Accept': 'application/json',
      },
    ),
  );
}