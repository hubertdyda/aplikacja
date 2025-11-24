import 'package:flutter/foundation.dart';

import '../dane/modele/model_meczu.dart';
import '../dane/repozytoria/repozytorium_meczy.dart';

class ListaMeczyModelWidoku extends ChangeNotifier {
  final RepozytoriumMeczy _repozytorium = RepozytoriumMeczy();

  bool czyLaduje = false;
  String? blad;
  List<ModelMeczu> mecze = [];

  Future<void> pobierzMecze() async {
    try {
      czyLaduje = true;
      blad = null;
      notifyListeners();

      mecze = await _repozytorium.pobierzMecze();

      czyLaduje = false;
      notifyListeners();
    } catch (e) {
      czyLaduje = false;
      blad = 'Nie udało się pobrać meczów.';
      notifyListeners();
    }
  }
}