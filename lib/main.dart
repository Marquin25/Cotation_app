import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/current_quotes_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/error_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotações de Moedas',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA), // cinza bem claro
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          background: const Color(0xFFF5F6FA),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // títulos brancos
          foregroundColor: Colors.blue,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF23272F), 
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          background: const Color(0xFF23272F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, 
          foregroundColor: Colors.blue,
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.blue),
          titleTextStyle: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      themeMode: ThemeMode.system, 
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/current': (context) => const CurrentQuotesScreen(),
        '/converter': (context) => const ConverterScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/error': (context) => ErrorScreen(
              errorMessage: 'Erro desconhecido',
              onRetry: () => Navigator.of(context).pop(),
            ),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => ErrorScreen(
            errorMessage: 'Rota não encontrada',
            onRetry: () => Navigator.pop(context),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}