import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modele_widoku/lista_meczy_model_widoku.dart';
import '../../dane/modele/model_meczu.dart';

class EkranMecze extends StatefulWidget {
  const EkranMecze({super.key});

  @override
  State<EkranMecze> createState() => _EkranMeczeState();
}

class _EkranMeczeState extends State<EkranMecze> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ListaMeczyModelWidoku>().pobierzMecze();
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelWidoku = context.watch<ListaMeczyModelWidoku>();

    if (modelWidoku.czyLaduje) {
      return const Center(child: CircularProgressIndicator());
    }

    if (modelWidoku.blad != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(modelWidoku.blad!),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: modelWidoku.pobierzMecze,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    final wszystkieMecze = modelWidoku.mecze;

    final meczeRegularSeason = wszystkieMecze
        .where((mecz) => mecz.runda.startsWith('Regular Season'))
        .toList();

    if (meczeRegularSeason.isEmpty) {
      return const Center(child: Text('Brak meczów Regular Season.'));
    }

    final Map<String, List<ModelMeczu>> wedlugRundy = {};

    for (final mecz in meczeRegularSeason) {
      wedlugRundy.putIfAbsent(mecz.runda, () => []).add(mecz);
    }

    final rundyPosortowane = wedlugRundy.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.builder(
      itemCount: rundyPosortowane.length,
      itemBuilder: (context, index) {
        final runda = rundyPosortowane[index];
        final meczeWRundzie = wedlugRundy[runda]!;

        return ExpansionTile(
          title: Text(runda),
          children: meczeWRundzie.map((mecz) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: _kafelekMeczu(mecz),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _kafelekMeczu(ModelMeczu mecz) {
    final wynik =
        '${mecz.goleGospodarz ?? '-'} : ${mecz.goleGosc ?? '-'}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _logoDruzyny(mecz.gospodarzLogo),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      mecz.gospodarzNazwa,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                wynik,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      mecz.goscNazwa,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _logoDruzyny(mecz.goscLogo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoDruzyny(String url) {
    if (url.isEmpty) {
      return const Icon(Icons.shield);
    }

    return Image.network(
      url,
      width: 32,
      height: 32,
      errorBuilder: (_, __, ___) => const Icon(Icons.shield),
    );
  }
}