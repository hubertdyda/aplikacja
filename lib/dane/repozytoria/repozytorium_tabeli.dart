import '../modele/model_tabeli_wiersz.dart';
import '../zrodla/zrodlo_zdalne.dart';

class RepozytoriumTabeli {
  final ZrodloZdalne _zrodloZdalne = ZrodloZdalne();

  Future<List<ModelTabeliWiersz>> pobierzTabele() {
    return _zrodloZdalne.pobierzTabelePremierLeague();
  }
}