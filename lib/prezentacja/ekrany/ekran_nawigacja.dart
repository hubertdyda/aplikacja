import 'package:flutter/material.dart';

import 'ekran_glowny.dart';
import 'ekran_mecze.dart';

class EkranNawigacja extends StatefulWidget {
  const EkranNawigacja({super.key});

  @override
  State<EkranNawigacja> createState() => _EkranNawigacjaState();
}

class _EkranNawigacjaState extends State<EkranNawigacja> {
  int _wybranyIndeks = 0;

  final List<Widget> _ekrany = const [
    EkranGlowny(),
    EkranMecze(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _wybranyIndeks = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _ekrany[_wybranyIndeks],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _wybranyIndeks,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Drużyny',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Mecze 2023',
          ),
        ],
      ),
    );
  }
}