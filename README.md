# Premier League 2023/2024 App

Aplikacja mobilna Flutter prezentująca dane z ligi Premier League z sezonu 2023/2024.  
Umożliwia:

- przeglądanie drużyn,
- wyszukiwanie drużyn,
- wyświetlanie szczegółów drużyn,
- przeglądanie meczów, 
- wyświetlanie tabeli ligowej,
- porównywanie dwóch drużyn.


## Użyte API

Dane pochodzą z:
API-Football
https://www.api-football.com/documentation-v3


## Jak uruchomić projekt?

Uruchamianie aplikacji Flutter (projekt z GitHub) w Android Studio

1. Wymagania
   •	Flutter SDK zainstalowany i dodany do PATH
   •	Android Studio z pluginami Flutter i Dart
   •	Git zainstalowany w systemie

2. Pobranie projektu

Klonowanie repozytorium:

git clone https://github.com/hubertdyda/aplikacja.git
cd <repo>

lub pobranie ZIP z GitHub i rozpakowanie w dowolnym katalogu.

3. Otworzenie projektu

W Android Studio:

File → Open → wybór folderu projektu (tam gdzie jest pubspec.yaml)

4. Instalacja zależności

W katalogu projektu:

flutter pub get

5. Plik .env

W głównym katalogu dodać plik:

.env

zawartość .env:

API_FOOTBALL_KEY=a951b21be4b591d643e6258400c9df6e
LEAGUE_ID=39
SEASON=2023

W pubspec.yaml musi znajdować się:

assets:
- .env

6. Urządzenie lub emulator
   •	Emulator: Android Studio → Device Manager → utwórz i uruchom urządzenie
   •	Telefon: włączyć Debugowanie USB i podłączyć do komputera

Sprawdzenie urządzeń:

flutter devices

7. Uruchomienie aplikacji

Android Studio: zielony przycisk ▶

lub terminal:

flutter run

## Wspierane platformy

- Android
- iOS