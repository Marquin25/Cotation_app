import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../models/currency.dart';
import '../models/api_response.dart';
import 'error_screen.dart';

class CurrentQuotesScreen extends StatefulWidget {
  const CurrentQuotesScreen({super.key});

  @override
  State<CurrentQuotesScreen> createState() => _CurrentQuotesScreenState();
}

class _CurrentQuotesScreenState extends State<CurrentQuotesScreen> {
  final CurrencyService _service = CurrencyService();
  late Future<ApiResponse<List<Currency>>> _quotesFuture;

  final List<String> currencies = ['USD', 'EUR', 'BRL', 'BTC', 'ETH', 'XRP', 'SOL'];

  @override
  void initState() {
    super.initState();
    _quotesFuture = _service.getCurrentQuotes();
  }

  void _refresh() {
    setState(() {
      _quotesFuture = _service.getCurrentQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotações Atuais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: FutureBuilder<ApiResponse<List<Currency>>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorScreen(
              errorMessage: 'Erro ao carregar dados',
              onRetry: _refresh,
            );
          }

          if (!snapshot.hasData || snapshot.data!.error != null) {
            return ErrorScreen(
              errorMessage: snapshot.data?.error ?? 'Dados não disponíveis',
              onRetry: _refresh,
            );
          }

          final currencies = snapshot.data!.data!;

          if (currencies.isEmpty) {
            return const Center(child: Text('Nenhuma cotação disponível'));
          }

          return ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${currency.name} (${currency.code})'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Compra: R\$ ${currency.bid.toStringAsFixed(4)}'),
                      Text('Venda: R\$ ${currency.ask.toStringAsFixed(4)}'),
                    ],
                  ),
                  trailing: Text(
                    '${currency.variation > 0 ? '+' : ''}${currency.variation.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: currency.variation > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}