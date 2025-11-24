import 'package:flutter/foundation.dart';

import '../dane/modele/model_druzyny.dart';
import '../dane/repozytoria/repozytorium_druzyn.dart';

class ListaDruzynModelWidoku extends ChangeNotifier {
  final RepozytoriumDruzyn _repozytorium = RepozytoriumDruzyn();

  bool czyLaduje = false;
  String? blad;
  List<ModelDruzyny> wszystkieDruzyny = [];
  List<ModelDruzyny> filtrowaneDruzyny = [];

  Future<void> pobierzDruzyny() async {
    try {
      czyLaduje = true;
      blad = null;
      notifyListeners();

      final druzyny = await _repozytorium.pobierzDruzyny();
      wszystkieDruzyny = druzyny;
      filtrowaneDruzyny = druzyny;

      czyLaduje = false;
      notifyListeners();
    } catch (e) {
      czyLaduje = false;
      blad = 'Nie udało się pobrać drużyn. Spróbuj ponownie.';
      notifyListeners();
    }
  }

  void filtruj(String tekst) {
    final query = tekst.toLowerCase();
    filtrowaneDruzyny = wszystkieDruzyny.where((druzyna) {
      return druzyna.nazwa.toLowerCase().contains(query) ||
          druzyna.miasto.toLowerCase().contains(query);
    }).toList();
    notifyListeners();
  }
}