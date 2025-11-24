import '../modele/model_druzyny.dart';
import '../zrodla/zrodlo_zdalne.dart';

class RepozytoriumDruzyn {
  final ZrodloZdalne _zrodloZdalne = ZrodloZdalne();

  Future<List<ModelDruzyny>> pobierzDruzyny() {
    // na razie tylko z API (offline dodamy później)
    return _zrodloZdalne.pobierzDruzynyPremierLeague();
  }
}