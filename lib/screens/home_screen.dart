import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<_HomeOption> options = [
      _HomeOption(
        icon: Icons.attach_money,
        label: 'Cotações Atuais',
        route: '/current',
      ),
      _HomeOption(
        icon: Icons.swap_horiz,
        label: 'Converter Moeda',
        route: '/converter',
      ),
      _HomeOption(
        icon: Icons.history,
        label: 'Histórico',
        route: '/history',
      ),
      _HomeOption(
        icon: Icons.settings,
        label: 'Configurações',
        route: '/settings',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 1.1,
          children: options.map((option) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                padding: const EdgeInsets.all(12),
              ),
              onPressed: () => Navigator.pushNamed(context, option.route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(option.icon, size: 48, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    option.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HomeOption {
  final IconData icon;
  final String label;
  final String route;

  _HomeOption({
    required this.icon,
    required this.label,
    required this.route,
  });
}
