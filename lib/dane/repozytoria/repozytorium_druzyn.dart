import '../modele/model_druzyny.dart';
import '../zrodla/zrodlo_zdalne.dart';

class RepozytoriumDruzyn {
  final ZrodloZdalne _zrodloZdalne = ZrodloZdalne();

  Future<List<ModelDruzyny>> pobierzDruzyny() {
    return _zrodloZdalne.pobierzDruzynyPremierLeague();
  }
}