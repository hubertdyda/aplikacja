import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modele_widoku/lista_druzyn_model_widoku.dart';
import 'modele_widoku/lista_meczy_model_widoku.dart';
import 'modele_widoku/tabela_model_widoku.dart';
import 'modele_widoku/pojedynek_model_widoku.dart';
import 'prezentacja/ekrany/ekran_glowny.dart';

class Aplikacja extends StatelessWidget {
  const Aplikacja({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListaDruzynModelWidoku()),
        ChangeNotifierProvider(create: (_) => ListaMeczyModelWidoku()),
        ChangeNotifierProvider(create: (_) => TabelaModelWidoku()),
        ChangeNotifierProvider(create: (_) => PojedynekModelWidoku()),
      ],
      child: MaterialApp(
        title: 'Premier League App',
        debugShowCheckedModeBanner: false,
        theme: _motywJasny,
        home: const EkranGlowny(),
      ),
    );
  }
}

//
// 🌟 NOWOCZESNY MOTYW (Material 3)
// Kolor przewodni: elegancki fiolet Premier League
//

final ThemeData _motywJasny = ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF38003C), // Premier League fiolet
    brightness: Brightness.light,
  ),

  scaffoldBackgroundColor: const Color(0xFFF4F5F7),

  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black87,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    elevation: 10,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xFF38003C),
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),

  cardTheme: CardThemeData(
    elevation: 3,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF38003C),
        width: 1.8,
      ),
    ),
  ),
);