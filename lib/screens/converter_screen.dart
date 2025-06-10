import 'package:flutter/material.dart';
import '../services/currency_service.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final CurrencyService _service = CurrencyService();
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'BRL';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  final List<String> _currencies = ['USD', 'EUR', 'BRL', 'BTC', 'SOL', 'XRP', 'DOGE', 'ETH'];

  void _convert() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    
    if (amount <= 0) {
      setState(() {
        _errorMessage = 'Digite um valor válido';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _service.convertCurrency(
      _fromCurrency,
      _toCurrency,
      amount,
    );

    setState(() {
      _isLoading = false;
      if (response.error != null) {
        _errorMessage = response.error;
      } else {
        _convertedAmount = response.data ?? 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de Moedas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fromCurrency,
                    items: _currencies
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _fromCurrency = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'De',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _toCurrency,
                    items: _currencies
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _toCurrency = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Para',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Converter'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else if (_convertedAmount > 0)
              Text(
                'Resultado: ${_convertedAmount.toStringAsFixed(2)} $_toCurrency',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}