import 'package:flutter/material.dart';
import '../../dane/modele/model_druzyny.dart';

class EkranSzczegolyDruzyny extends StatelessWidget {
  final ModelDruzyny druzyna;

  const EkranSzczegolyDruzyny({
    super.key,
    required this.druzyna,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(druzyna.nazwa),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: druzyna.logoUrl.isNotEmpty
                  ? Image.network(
                druzyna.logoUrl,
                width: 120,
                height: 120,
              )
                  : const Icon(Icons.shield, size: 80),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                druzyna.nazwa,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${druzyna.kraj} • ${druzyna.miasto}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _wierszInfo('Kod', druzyna.kod),
            _wierszInfo(
              'Rok założenia',
              druzyna.rokZalozenia?.toString() ?? 'brak danych',
            ),
            _wierszInfo('Stadion', druzyna.stadion),
          ],
        ),
      ),
    );
  }

  Widget _wierszInfo(String etykieta, String wartosc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$etykieta: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(wartosc),
          ),
        ],
      ),
    );
  }
}