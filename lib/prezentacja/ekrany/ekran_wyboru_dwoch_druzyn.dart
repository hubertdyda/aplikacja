import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modele_widoku/lista_druzyn_model_widoku.dart';
import '../../dane/modele/model_druzyny.dart';

class EkranWyboruDwochDruzyn extends StatefulWidget {
  const EkranWyboruDwochDruzyn({super.key});

  @override
  State<EkranWyboruDwochDruzyn> createState() => _EkranWyboruDwochDruzynState();
}

class _EkranWyboruDwochDruzynState extends State<EkranWyboruDwochDruzyn> {
  ModelDruzyny? _pierwszaDruzyna;
  ModelDruzyny? _drugaDruzyna;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final modelWidoku = context.read<ListaDruzynModelWidoku>();
      if (modelWidoku.wszystkieDruzyny.isEmpty) {
        modelWidoku.pobierzDruzyny();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final modelWidoku = context.watch<ListaDruzynModelWidoku>();

    final czyLaduje = modelWidoku.czyLaduje && modelWidoku.wszystkieDruzyny.isEmpty;
    final blad = modelWidoku.blad;
    final druzyny = modelWidoku.wszystkieDruzyny;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz dwie drużyny'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) {
            if (czyLaduje) {
              return const Center(child: CircularProgressIndicator());
            }

            if (blad != null && druzyny.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(blad),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: modelWidoku.pobierzDruzyny,
                      child: const Text('Spróbuj ponownie'),
                    ),
                  ],
                ),
              );
            }

            if (druzyny.isEmpty) {
              return const Center(
                child: Text('Brak dostępnych drużyn.'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pierwsza drużyna',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ModelDruzyny>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Wybierz drużynę',
                  ),
                  value: _pierwszaDruzyna,
                  items: druzyny.map((druzyna) {
                    return DropdownMenuItem<ModelDruzyny>(
                      value: druzyna,
                      child: Row(
                        children: [
                          if (druzyna.logoUrl.isNotEmpty)
                            Image.network(
                              druzyna.logoUrl,
                              width: 24,
                              height: 24,
                            ),
                          const SizedBox(width: 8),
                          Text(druzyna.nazwa),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (nowa) {
                    setState(() {
                      _pierwszaDruzyna = nowa;
                    });
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Druga drużyna',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ModelDruzyny>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Wybierz drużynę',
                  ),
                  value: _drugaDruzyna,
                  items: druzyny.map((druzyna) {
                    return DropdownMenuItem<ModelDruzyny>(
                      value: druzyna,
                      child: Row(
                        children: [
                          if (druzyna.logoUrl.isNotEmpty)
                            Image.network(
                              druzyna.logoUrl,
                              width: 24,
                              height: 24,
                            ),
                          const SizedBox(width: 8),
                          Text(druzyna.nazwa),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (nowa) {
                    setState(() {
                      _drugaDruzyna = nowa;
                    });
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  'Na tym etapie tylko wybieramy drużyny.\nPóźniej tutaj dodamy wyszukiwanie wyniku.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}