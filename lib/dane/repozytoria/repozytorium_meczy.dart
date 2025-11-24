import '../modele/model_meczu.dart';
import '../zrodla/zrodlo_zdalne.dart';

class RepozytoriumMeczy {
  final ZrodloZdalne _zrodloZdalne = ZrodloZdalne();

  Future<List<ModelMeczu>> pobierzMecze() {
    return _zrodloZdalne.pobierzMeczePremierLeague();
  }
  Future<List<ModelMeczu>> pobierzMeczeHeadToHead(
      int teamId1, int teamId2) {
    return _zrodloZdalne.pobierzMeczeHeadToHead(
      teamId1: teamId1,
      teamId2: teamId2,
    );
  }
}