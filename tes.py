import shutil
import os

# Caminho do projeto Flutter criado anteriormente (estrutura local simulada)
project_name = "clima_agora_flutter_app"
project_path = f"/mnt/data/{project_name}"

# Certifique-se de que a pasta existe
os.makedirs(project_path, exist_ok=True)

# Estrutura básica do projeto (pastas principais)
folders = [
    "lib/screens",
    "lib/services",
    "assets",
]

# Cria pastas do projeto
for folder in folders:
    os.makedirs(os.path.join(project_path, folder), exist_ok=True)

# Arquivos principais do projeto
files = {
    "pubspec.yaml": """
name: clima_agora
description: Aplicativo de clima com Flutter.
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5

flutter:
  uses-material-design: true
""",

    "lib/main.dart": """
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/result_screen.dart';
import 'screens/error_screen.dart';
import 'screens/empty_screen.dart';

void main() {
  runApp(const ClimaAgoraApp());
}

class ClimaAgoraApp extends StatelessWidget {
  const ClimaAgoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clima Agora',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/result': (context) => const ResultScreen(),
        '/error': (context) => const ErrorScreen(),
        '/empty': (context) => const EmptyScreen(),
      },
    );
  }
""",

    "lib/screens/home_screen.dart": """
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima Agora')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Digite uma cidade:'),
            TextField(controller: _controller),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  Navigator.pushNamed(context, '/loading',
                      arguments: _controller.text.trim());
                }
              },
              child: const Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
""",

    "lib/screens/loading_screen.dart": """
import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final city = ModalRoute.of(context)!.settings.arguments as String;
    fetchWeather(city);
  }

  void fetchWeather(String city) async {
    final weather = await WeatherService.getWeather(city);
    if (weather == null) {
      Navigator.pushReplacementNamed(context, '/error');
    } else if (weather['main'] == null) {
      Navigator.pushReplacementNamed(context, '/empty');
    } else {
      Navigator.pushReplacementNamed(context, '/result', arguments: weather);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
""",

    "lib/screens/result_screen.dart": """
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weather = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Cidade: ${weather['name']}'),
            Text('Temperatura: ${weather['main']['temp']}°C'),
            Text('Clima: ${weather['weather'][0]['description']}'),
          ],
        ),
      ),
    );
  }
}
""",

    "lib/screens/error_screen.dart": """
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Erro ao buscar dados. Tente novamente.'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            )
          ],
        ),
      ),
    );
  }
}
""",

    "lib/screens/empty_screen.dart": """
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nenhum dado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nenhum dado encontrado para esta cidade.'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            )
          ],
        ),
      ),
    );
  }
}
""",

    "lib/services/weather_service.dart": """
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'SUA_API_KEY_AQUI'; // Substitua pela sua chave real

  static Future<Map?> getWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric&lang=pt_br',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
""",
}

# Escreve os arquivos
for filepath, content in files.items():
    full_path = os.path.join(project_path, filepath)
    with open(full_path, "w") as f:
        f.write(content.strip())

# Gera o ZIP
zip_path = f"/mnt/data/{project_name}.zip"
shutil.make_archive(zip_path.replace(".zip", ""), 'zip', project_path)

zip_path
