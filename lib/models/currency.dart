// currency.dart
class Currency {
  final String code;
  final String name;
  final double bid;
  final double ask;
  final double variation;

  Currency({
    required this.code,
    required this.name,
    required this.bid,
    required this.ask,
    required this.variation,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      bid: double.tryParse(json['bid'].toString()) ?? 0.0,
      ask: double.tryParse(json['ask'].toString()) ?? 0.0,
      variation: double.tryParse(json['varBid'].toString()) ?? 0.0,
    );
  }
}