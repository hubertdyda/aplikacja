import 'package:flutter/foundation.dart';

import '../dane/modele/model_tabeli_wiersz.dart';
import '../dane/repozytoria/repozytorium_tabeli.dart';

class TabelaModelWidoku extends ChangeNotifier {
  final RepozytoriumTabeli _repozytorium = RepozytoriumTabeli();

  bool czyLaduje = false;
  String? blad;
  List<ModelTabeliWiersz> wiersze = [];

  Future<void> pobierzTabele() async {
    try {
      czyLaduje = true;
      blad = null;
      notifyListeners();

      wiersze = await _repozytorium.pobierzTabele();

      czyLaduje = false;
      notifyListeners();
    } catch (e) {
      czyLaduje = false;
      blad = 'Nie udało się pobrać tabeli.';
      notifyListeners();
    }
  }
}