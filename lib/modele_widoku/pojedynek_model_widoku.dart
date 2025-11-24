import 'package:flutter/foundation.dart';

import '../dane/modele/model_meczu.dart';
import '../dane/repozytoria/repozytorium_pojedynku.dart';

class PojedynekModelWidoku extends ChangeNotifier {
  final RepozytoriumPojedynku _repozytoriumPojedynku = RepozytoriumPojedynku();

  bool czyLaduje = false;
  String? blad;
  List<ModelMeczu> meczeH2H = [];

  Future<void> szukajPojedynek({
    required int teamId1,
    required int teamId2,
  }) async {
    try {
      czyLaduje = true;
      blad = null;
      meczeH2H = [];
      notifyListeners();

      final wyniki = await _repozytoriumPojedynku.pobierzPojedynek(
        teamId1: teamId1,
        teamId2: teamId2,
      );

      meczeH2H = wyniki;
      czyLaduje = false;
      notifyListeners();
    } catch (e) {
      czyLaduje = false;
      blad = 'Nie udało się pobrać wyników bezpośrednich (H2H).';
      notifyListeners();
    }
  }
}