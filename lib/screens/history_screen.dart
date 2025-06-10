import 'package:flutter/material.dart';
import '../services/currency_service.dart';
import '../models/api_response.dart';
import 'error_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final CurrencyService _service = CurrencyService();
  late Future<ApiResponse<List<Map<String, dynamic>>>> _historyFuture;
  String _selectedCurrency = 'USD-BRL';
  int _days = 30;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> _fetchHistory() async {
    try {
      final response = await _service.getHistory(_selectedCurrency, _days);
      return ApiResponse.success(response);
    } catch (e) {
      return ApiResponse.error('Erro ao carregar histórico: $e');
    }
  }

  void _refresh() {
    setState(() {
      _historyFuture = _fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    items: ['USD-BRL', 'EUR-BRL', 'BTC-BRL']
                        .map((pair) => DropdownMenuItem(
                              value: pair,
                              child: Text(pair),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value!;
                        _refresh();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _days,
                    items: [7, 15, 30, 60, 90]
                        .map((days) => DropdownMenuItem(
                              value: days,
                              child: Text('Últimos $days dias'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _days = value!;
                        _refresh();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<ApiResponse<List<Map<String, dynamic>>>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || snapshot.data?.error != null) {
                  return ErrorScreen(
                    errorMessage: snapshot.data?.error ?? 'Erro desconhecido',
                    onRetry: _refresh,
                  );
                }

                if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return const Center(child: Text('Nenhum dado histórico disponível'));
                }

                final historyData = snapshot.data!.data!;

                return ListView.builder(
                  itemCount: historyData.length,
                  itemBuilder: (context, index) {
                    final item = historyData[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(item['timestamp']?.toString() ?? 'Data desconhecida'),
                        subtitle: Text('Valor: R\$ ${double.tryParse(item['bid']?.toString() ?? '')?.toStringAsFixed(4) ?? 'N/A'}'),
                        trailing: Text(
                          (() {
                            final varBid = double.tryParse(item['varBid']?.toString() ?? '');
                            if (varBid == null) return '0.00%';
                            return '${varBid > 0 ? '+' : ''}${varBid.toStringAsFixed(2)}%';
                          })(),
                          style: TextStyle(
                            color: (double.tryParse(item['varBid']?.toString() ?? '0') ?? 0) > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}