import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificações'),
            value: true,
            onChanged: (value) {},
          ),
          const ListTile(
            title: Text('Tema'),
            subtitle: Text('Claro'),
          ),
          const ListTile(
            title: Text('Versão'),
            subtitle: Text('2.0'),
          ),
          ListTile(
            title: const Text('Sobre'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Cotações de Moedas',
                applicationVersion: '1.0.0',
                children: [
                  const Text('Aplicativo para consulta de cotações de moedas'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}