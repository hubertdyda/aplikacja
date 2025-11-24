import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../modele/model_druzyny.dart';
import '../modele/model_meczu.dart';
import '../modele/model_tabeli_wiersz.dart';
import 'klient_api.dart';

class ZrodloZdalne {
  final KlientApi _klientApi = KlientApi();

  Future<List<ModelDruzyny>> pobierzDruzynyPremierLeague() async {
    final leagueId = dotenv.env['LEAGUE_ID'] ?? '39';
    final season = dotenv.env['SEASON'] ?? '2023';

    final response = await _klientApi.dio.get(
      '/teams',
      queryParameters: {
        'league': leagueId,
        'season': season,
      },
    );

    if (response.statusCode == 200) {
      final dane = response.data['response'] as List<dynamic>;
      return dane
          .map((e) => ModelDruzyny.zApi(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Błąd podczas pobierania drużyn: ${response.statusCode}');
    }
  }

  Future<List<ModelMeczu>> pobierzMeczePremierLeague() async {
    final leagueId = dotenv.env['LEAGUE_ID'] ?? '39';
    final season = dotenv.env['SEASON'] ?? '2023';

    final response = await _klientApi.dio.get(
      '/fixtures',
      queryParameters: {
        'league': leagueId,
        'season': season,
      },
    );

    if (response.statusCode == 200) {
      final dane = response.data['response'] as List<dynamic>;
      return dane
          .map((e) => ModelMeczu.zApi(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Błąd podczas pobierania meczów: ${response.statusCode}');
    }
  }
  Future<List<ModelMeczu>> pobierzMeczeH2H({
    required int teamId1,
    required int teamId2,
  }) async {
    final leagueId = dotenv.env['LEAGUE_ID'] ?? '39';
    final season = dotenv.env['SEASON'] ?? '2023';

    final response = await _klientApi.dio.get(
      '/fixtures/headtohead',
      queryParameters: {
        'h2h': '$teamId1-$teamId2',
        'league': leagueId,
        'season': season,
      },
    );

    if (response.statusCode == 200) {
      final dane = response.data['response'] as List<dynamic>;
      return dane
          .map((e) => ModelMeczu.zApi(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Błąd podczas pobierania H2H: ${response.statusCode}');
    }
  }
  Future<List<ModelTabeliWiersz>> pobierzTabelePremierLeague() async {
    final leagueId = dotenv.env['LEAGUE_ID'] ?? '39';
    final season = dotenv.env['SEASON'] ?? '2023';

    final response = await _klientApi.dio.get(
      '/standings',
      queryParameters: {
        'league': leagueId,
        'season': season,
      },
    );

    if (response.statusCode == 200) {
      final dane = response.data['response'] as List<dynamic>;
      if (dane.isEmpty) return [];

      final league = dane[0]['league'] ?? {};
      final standings = league['standings'] as List<dynamic>;
      final pierwszaGrupa = standings.first as List<dynamic>;

      return pierwszaGrupa
          .map((e) => ModelTabeliWiersz.zApi(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Błąd podczas pobierania tabeli: ${response.statusCode}');
    }
  }
  Future<List<ModelMeczu>> pobierzMeczeHeadToHead({
    required int teamId1,
    required int teamId2,
  }) async {
    final response = await _klientApi.dio.get(
      '/fixtures/headtohead',
      queryParameters: {
        'h2h': '$teamId1-$teamId2',
      },
    );

    if (response.statusCode == 200) {
      final dane = response.data['response'] as List<dynamic>;
      return dane
          .map((e) => ModelMeczu.zApi(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Błąd podczas pobierania H2H: ${response.statusCode}');
    }
  }
}