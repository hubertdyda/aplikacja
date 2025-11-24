class ModelTabeliWiersz {
  final int pozycja;
  final int teamId;
  final String nazwa;
  final String logo;
  final int rozegrane;
  final int wygrane;
  final int remisy;
  final int porazki;
  final int goleStrzelone;
  final int goleStracone;
  final int roznicaGoli;
  final int punkty;

  ModelTabeliWiersz({
    required this.pozycja,
    required this.teamId,
    required this.nazwa,
    required this.logo,
    required this.rozegrane,
    required this.wygrane,
    required this.remisy,
    required this.porazki,
    required this.goleStrzelone,
    required this.goleStracone,
    required this.roznicaGoli,
    required this.punkty,
  });

  factory ModelTabeliWiersz.zApi(Map<String, dynamic> json) {
    final team = json['team'] ?? {};
    final all = json['all'] ?? {};
    final goals = all['goals'] ?? {};

    return ModelTabeliWiersz(
      pozycja: json['rank'] ?? 0,
      teamId: team['id'] ?? 0,
      nazwa: team['name'] ?? '',
      logo: team['logo'] ?? '',
      rozegrane: all['played'] ?? 0,
      wygrane: all['win'] ?? 0,
      remisy: all['draw'] ?? 0,
      porazki: all['lose'] ?? 0,
      goleStrzelone: goals['for'] ?? 0,
      goleStracone: goals['against'] ?? 0,
      roznicaGoli: json['goalsDiff'] ?? 0,
      punkty: json['points'] ?? 0,
    );
  }
}