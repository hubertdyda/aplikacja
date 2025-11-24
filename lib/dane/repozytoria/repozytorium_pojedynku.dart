import '../modele/model_meczu.dart';
import '../zrodla/zrodlo_zdalne.dart';

class RepozytoriumPojedynku {
  final ZrodloZdalne _zrodloZdalne = ZrodloZdalne();

  Future<List<ModelMeczu>> pobierzPojedynek({
    required int teamId1,
    required int teamId2,
  }) {
    return _zrodloZdalne.pobierzMeczeH2H(
      teamId1: teamId1,
      teamId2: teamId2,
    );
  }
}