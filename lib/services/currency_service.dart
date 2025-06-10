import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';
import '../models/api_response.dart';
import '../utils/constants.dart';

class CurrencyService {
  Future<ApiResponse<List<Currency>>> getCurrentQuotes() async {
    try {
      final response = await http.get(Uri.parse(Constants.currentQuotesUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final currencies = <Currency>[];
        
        data.forEach((key, value) {
          if (key != 'USDT') { 
            currencies.add(Currency.fromJson(value));
          }
        });
        
        return ApiResponse.success(currencies);
      } else {
        return ApiResponse.error('Erro ao carregar cotações: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Erro de conexão: $e');
    }
  }

  Future<ApiResponse<double>> convertCurrency(
      String from, String to, double amount) async {
    try {
      final url = '${Constants.converterUrl}$from-$to';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final key = '$from$to'.replaceAll('-', '');
        final bid = double.tryParse(data[key]['bid'].toString()) ?? 0.0;
        return ApiResponse.success(bid * amount);
      } else {
        return ApiResponse.error('Erro na conversão: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Erro de conexão: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistory(String currency, int days) async {
    try {
      final url = '${Constants.historyUrl}$currency?days=$days';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Erro ao carregar histórico: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}