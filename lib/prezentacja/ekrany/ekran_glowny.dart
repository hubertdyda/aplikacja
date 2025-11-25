import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modele_widoku/lista_druzyn_model_widoku.dart';
import '../../modele_widoku/lista_meczy_model_widoku.dart';
import '../../modele_widoku/pojedynek_model_widoku.dart';
import '../../modele_widoku/tabela_model_widoku.dart';
import '../../dane/modele/model_druzyny.dart';
import '../../dane/modele/model_meczu.dart';
import '../../dane/modele/model_tabeli_wiersz.dart';

class EkranGlowny extends StatefulWidget {
  const EkranGlowny({super.key});

  @override
  State<EkranGlowny> createState() => _EkranGlownyState();
}

class _EkranGlownyState extends State<EkranGlowny> {
  final TextEditingController _wyszukiwarkaController = TextEditingController();

  int _wybranyIndex = 0;

  ModelDruzyny? _wybranaDruzyna1;
  ModelDruzyny? _wybranaDruzyna2;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ListaDruzynModelWidoku>().pobierzDruzyny();
      context.read<ListaMeczyModelWidoku>().pobierzMecze();
      context.read<TabelaModelWidoku>().pobierzTabele();
    });
  }

  @override
  void dispose() {
    _wyszukiwarkaController.dispose();
    super.dispose();
  }

  String _tytulAppBar() {
    switch (_wybranyIndex) {
      case 0:
        return 'Premier League 2023/2024';
      case 1:
        return 'Premier League 2023/2024';
      case 2:
        return 'Premier League 2023/2024';
      case 3:
        return 'Premier League 2023/2024';
      default:
        return 'Premier League';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tytulAppBar()),
      ),
      body: _zbudujCialo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _wybranyIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _wybranyIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Drużyny',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Mecze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'Tabela',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Pojedynek',
          ),
        ],
      ),
    );
  }

  Widget _zbudujCialo() {
    switch (_wybranyIndex) {
      case 0:
        return _zakladkaDruzyny();
      case 1:
        return _zakladkaMecze();
      case 2:
        return _zakladkaTabela();
      case 3:
        return _zakladkaPojedynek();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _zakladkaDruzyny() {
    final modelWidoku = context.watch<ListaDruzynModelWidoku>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _wyszukiwarkaController,
            decoration: const InputDecoration(
              labelText: 'Szukaj drużyny...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: modelWidoku.filtruj,
          ),
        ),
        Expanded(
          child: _zbudujListeDruzyn(modelWidoku),
        ),
      ],
    );
  }

  Widget _zbudujListeDruzyn(ListaDruzynModelWidoku modelWidoku) {
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
              onPressed: modelWidoku.pobierzDruzyny,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    if (modelWidoku.filtrowaneDruzyny.isEmpty) {
      return const Center(
        child: Text('Brak wyników.'),
      );
    }

    final druzyny = modelWidoku.filtrowaneDruzyny;

    return ListView.builder(
      itemCount: druzyny.length,
      itemBuilder: (context, index) {
        final ModelDruzyny druzyna = druzyny[index];
        return ListTile(
          leading: druzyna.logoUrl.isNotEmpty
              ? Image.network(
            druzyna.logoUrl,
            width: 40,
            height: 40,
          )
              : const Icon(Icons.shield),
          title: Text(druzyna.nazwa),
          subtitle: Text('${druzyna.miasto} • ${druzyna.kraj}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EkranSzczegolyDruzyny(druzyna: druzyna),
              ),
            );
          },
        );
      },
    );
  }

  Widget _zakladkaMecze() {
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

    if (modelWidoku.mecze.isEmpty) {
      return const Center(
        child: Text('Brak meczów do wyświetlenia.'),
      );
    }

    final mecze = modelWidoku.mecze;

    final Map<String, List<ModelMeczu>> meczePoRundzie = {};
    for (final mecz in mecze) {
      final runda = mecz.runda;
      if (!meczePoRundzie.containsKey(runda)) {
        meczePoRundzie[runda] = [];
      }
      meczePoRundzie[runda]!.add(mecz);
    }

    final rundy = meczePoRundzie.keys.toList()
      ..sort((a, b) {
        int extractNumber(String text) {
          final parts = text.split('-');
          if (parts.length < 2) return 0;
          return int.tryParse(parts.last.trim()) ?? 0;
        }

        final na = extractNumber(a);
        final nb = extractNumber(b);
        return na.compareTo(nb);
      });

    return ListView.builder(
      itemCount: rundy.length,
      itemBuilder: (context, index) {
        final runda = rundy[index];
        final meczeRundy = meczePoRundzie[runda] ?? [];

        return ExpansionTile(
          title: Text(
            _zakresDatRundy(meczeRundy),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: meczeRundy
              .map((mecz) => _zbudujListeMeczyZRundy(mecz))
              .toList(),
        );

      },
    );
  }
  Widget _zbudujListeMeczyZRundy(ModelMeczu mecz) {
    final dataTekst = mecz.data != null
        ? '${mecz.data!.day.toString().padLeft(2, '0')}.'
        '${mecz.data!.month.toString().padLeft(2, '0')}.'
        '${mecz.data!.year}'
        : '';
    final godzinaTekst = mecz.data != null
        ? '${mecz.data!.hour.toString().padLeft(2, '0')}:'
        '${mecz.data!.minute.toString().padLeft(2, '0')}'
        : '';

    final wynik = (mecz.goleGospodarz != null && mecz.goleGosc != null)
        ? '${mecz.goleGospodarz} : ${mecz.goleGosc}'
        : '- : -';

    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(dataTekst),
          Text(
            godzinaTekst,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      title: Text('${mecz.nazwaGospodarz} vs ${mecz.nazwaGosc}'),
      subtitle: Text(mecz.runda),
      trailing: Text(
        wynik,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
  String _zakresDatRundy(List<ModelMeczu> mecze) {
    final daty = mecze
        .where((m) => m.data != null)
        .map((m) => m.data!)
        .toList()
      ..sort();

    if (daty.isEmpty) return '';

    String format(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}.'
            '${d.month.toString().padLeft(2, '0')}.'
            '${d.year}';

    final pierwsza = daty.first;
    final ostatnia = daty.last;

    return '${format(pierwsza)} - ${format(ostatnia)}';
  }
  Widget _zakladkaTabela() {
    final modelWidoku = context.watch<TabelaModelWidoku>();

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
              onPressed: modelWidoku.pobierzTabele,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    if (modelWidoku.wiersze.isEmpty) {
      return const Center(
        child: Text('Brak danych tabeli.'),
      );
    }

    final wiersze = modelWidoku.wiersze;

    return ListView.builder(
      itemCount: wiersze.length,
      itemBuilder: (context, index) {
        final ModelTabeliWiersz w = wiersze[index];
        return ListTile(
          leading: Text(
            w.pozycja.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          title: Row(
            children: [
              if (w.logo.isNotEmpty)
                Image.network(
                  w.logo,
                  width: 24,
                  height: 24,
                ),
              const SizedBox(width: 8),
              Expanded(child: Text(w.nazwa)),
            ],
          ),
          subtitle: Text(
            'M:${w.rozegrane}  W:${w.wygrane} R:${w.remisy} P:${w.porazki}  '
                'G:${w.goleStrzelone}-${w.goleStracone}',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                w.punkty.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('DG: ${w.roznicaGoli}'),
            ],
          ),
        );
      },
    );
  }

  Widget _zakladkaPojedynek() {
    final modelWidoku = context.watch<ListaDruzynModelWidoku>();
    final pojedynekVM = context.watch<PojedynekModelWidoku>();

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
              onPressed: modelWidoku.pobierzDruzyny,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    if (modelWidoku.wszystkieDruzyny.isEmpty) {
      return const Center(
        child: Text('Brak drużyn do wyboru.'),
      );
    }

    final druzyny = modelWidoku.wszystkieDruzyny;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Wybierz dwie drużyny:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<ModelDruzyny>(
            decoration: const InputDecoration(
              labelText: 'Drużyna 1',
              border: OutlineInputBorder(),
            ),
            value: _wybranaDruzyna1,
            items: druzyny.map((d) {
              return DropdownMenuItem<ModelDruzyny>(
                value: d,
                child: Text(d.nazwa),
              );
            }).toList(),
            onChanged: (nowa) {
              setState(() {
                _wybranaDruzyna1 = nowa;
              });
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<ModelDruzyny>(
            decoration: const InputDecoration(
              labelText: 'Drużyna 2',
              border: OutlineInputBorder(),
            ),
            value: _wybranaDruzyna2,
            items: druzyny.map((d) {
              return DropdownMenuItem<ModelDruzyny>(
                value: d,
                child: Text(d.nazwa),
              );
            }).toList(),
            onChanged: (nowa) {
              setState(() {
                _wybranaDruzyna2 = nowa;
              });
            },
          ),

          const SizedBox(height: 24),

          if (_wybranaDruzyna1 != null && _wybranaDruzyna2 != null)
            Text(
              'Wybrano: ${_wybranaDruzyna1!.nazwa} vs ${_wybranaDruzyna2!.nazwa}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () {
              if (_wybranaDruzyna1 == null || _wybranaDruzyna2 == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wybierz dwie drużyny')),
                );
                return;
              }

              context.read<PojedynekModelWidoku>().szukajPojedynek(
                teamId1: _wybranaDruzyna1!.id,
                teamId2: _wybranaDruzyna2!.id,
              );
            },
            child: const Text('Szukaj pojedynku'),
          ),

          const SizedBox(height: 16),
          Expanded(
            child: _zbudujListeH2H(pojedynekVM),
          ),
        ],
      ),
    );
  }
  Widget _zbudujListeH2H(PojedynekModelWidoku vm) {
    if (vm.czyLaduje) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.blad != null) {
      return Center(
        child: Text(vm.blad!),
      );
    }

    if (vm.meczeH2H.isEmpty) {
      return const Center(
        child: Text('Brak meczów do wyświetlenia.'),
      );
    }

    return ListView.builder(
      itemCount: vm.meczeH2H.length,
      itemBuilder: (context, index) {
        final mecz = vm.meczeH2H[index];

        final dataTekst = mecz.data != null
            ? '${mecz.data!.day.toString().padLeft(2, '0')}.'
            '${mecz.data!.month.toString().padLeft(2, '0')}.'
            '${mecz.data!.year}'
            : '';

        final wynik = (mecz.goleGospodarz != null && mecz.goleGosc != null)
            ? '${mecz.goleGospodarz} : ${mecz.goleGosc}'
            : '- : -';

        return ListTile(
          title: Text('${mecz.nazwaGospodarz} vs ${mecz.nazwaGosc}'),
          subtitle: Text(dataTekst),
          trailing: Text(
            wynik,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        );
      },
    );
  }
  Map<String, List<ModelMeczu>> _grupujMeczePoRundzie(List<ModelMeczu> mecze) {
    final Map<String, List<ModelMeczu>> grupy = {};

    for (final mecz in mecze) {
      final runda = mecz.runda.isNotEmpty ? mecz.runda : 'Inne';
      if (!grupy.containsKey(runda)) {
        grupy[runda] = [];
      }
      grupy[runda]!.add(mecz);
    }

    return grupy;
  }
  Widget _kafelekMeczu(ModelMeczu mecz) {
    final dataTekst = mecz.data != null
        ? '${mecz.data!.day.toString().padLeft(2, '0')}.'
        '${mecz.data!.month.toString().padLeft(2, '0')}.'
        '${mecz.data!.year}'
        : '';

    final godzinaTekst = mecz.data != null
        ? '${mecz.data!.hour.toString().padLeft(2, '0')}:'
        '${mecz.data!.minute.toString().padLeft(2, '0')}'
        : '';

    final wynik = (mecz.goleGospodarz != null && mecz.goleGosc != null)
        ? '${mecz.goleGospodarz} : ${mecz.goleGosc}'
        : '- : -';

    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dataTekst),
          Text(
            godzinaTekst,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      title: Text('${mecz.nazwaGospodarz} vs ${mecz.nazwaGosc}'),
      subtitle: Text(mecz.runda),
      trailing: Text(
        wynik,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}

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
                width: 100,
                height: 100,
              )
                  : const Icon(
                Icons.shield,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            _wierszInfo('Nazwa', druzyna.nazwa),
            _wierszInfo('Kraj', druzyna.kraj),
            _wierszInfo('Miasto', druzyna.miasto),
            if (druzyna.rokZalozenia != null)
              _wierszInfo('Rok założenia', druzyna.rokZalozenia.toString()),
            _wierszInfo('Kod', druzyna.kod),
          ],
        ),
      ),
    );
  }

  Widget _wierszInfo(String etykieta, String wartosc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$etykieta: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(wartosc),
          ),
        ],
      ),
    );
  }
}