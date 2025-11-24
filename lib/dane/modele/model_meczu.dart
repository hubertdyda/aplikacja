class ModelMeczu {
  final int id;
  final DateTime? data;
  final String statusKrotki;
  final String statusOpis;
  final String runda;
  final String nazwaGospodarz;
  final String nazwaGosc;
  final String logoGospodarz;
  final String logoGosc;
  final int? goleGospodarz;
  final int? goleGosc;

  ModelMeczu({
    required this.id,
    required this.data,
    required this.statusKrotki,
    required this.statusOpis,
    required this.runda,
    required this.nazwaGospodarz,
    required this.nazwaGosc,
    required this.logoGospodarz,
    required this.logoGosc,
    required this.goleGospodarz,
    required this.goleGosc,
  });

  factory ModelMeczu.zApi(Map<String, dynamic> json) {
    final fixture = json['fixture'] ?? {};
    final league = json['league'] ?? {};
    final teams = json['teams'] ?? {};
    final goals = json['goals'] ?? {};
    final home = teams['home'] ?? {};
    final away = teams['away'] ?? {};
    final status = fixture['status'] ?? {};

    return ModelMeczu(
      id: fixture['id'] ?? 0,
      data: DateTime.tryParse(fixture['date'] ?? ''),
      statusKrotki: status['short'] ?? '',
      statusOpis: status['long'] ?? '',
      runda: league['round'] ?? '',
      nazwaGospodarz: home['name'] ?? '',
      nazwaGosc: away['name'] ?? '',
      logoGospodarz: home['logo'] ?? '',
      logoGosc: away['logo'] ?? '',
      goleGospodarz: goals['home'],
      goleGosc: goals['away'],
    );
  }
}