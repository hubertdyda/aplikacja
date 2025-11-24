class ModelDruzyny {
  final int id;
  final String nazwa;
  final String kod;
  final String kraj;
  final int? rokZalozenia;
  final String logoUrl;
  final String stadion;
  final String miasto;

  ModelDruzyny({
    required this.id,
    required this.nazwa,
    required this.kod,
    required this.kraj,
    required this.rokZalozenia,
    required this.logoUrl,
    required this.stadion,
    required this.miasto,
  });

  factory ModelDruzyny.zApi(Map<String, dynamic> json) {
    final team = json['team'] ?? {};
    final venue = json['venue'] ?? {};

    return ModelDruzyny(
      id: team['id'] ?? 0,
      nazwa: team['name'] ?? '',
      kod: team['code'] ?? '',
      kraj: team['country'] ?? '',
      rokZalozenia: team['founded'],
      logoUrl: team['logo'] ?? '',
      stadion: venue['name'] ?? '',
      miasto: venue['city'] ?? '',
    );
  }
}