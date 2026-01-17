class CurrencyModel {
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final DateTime date;
  final double amount;
  final double result;

  CurrencyModel({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.date,
    required this.amount,
    required this.result,
  });

  factory CurrencyModel.fromJson(
    Map<String, dynamic> json,
    String from,
    String to,
    double inputAmount,
  ) {
    final rates = json['rates'] as Map<String, dynamic>?;
    final rate = rates?[to] as num? ?? 0.0;

    return CurrencyModel(
      baseCurrency: from,
      targetCurrency: to,
      rate: rate.toDouble(),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      amount: inputAmount,
      result: inputAmount * rate.toDouble(),
    );
  }

  factory CurrencyModel.fromConvertJson(Map<String, dynamic> json) {
    final query = json['query'] as Map<String, dynamic>?;
    final info = json['info'] as Map<String, dynamic>?;

    return CurrencyModel(
      baseCurrency: query?['from'] ?? '',
      targetCurrency: query?['to'] ?? '',
      rate: (info?['rate'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      amount: (query?['amount'] as num?)?.toDouble() ?? 0.0,
      result: (json['result'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // For ExchangeRate-API format
  factory CurrencyModel.fromExchangeRateJson(
    Map<String, dynamic> json,
    double inputAmount,
  ) {
    final timeLastUpdate = json['time_last_update_unix'] as int?;
    final date = timeLastUpdate != null
        ? DateTime.fromMillisecondsSinceEpoch(timeLastUpdate * 1000)
        : DateTime.now();

    return CurrencyModel(
      baseCurrency: json['base_code'] ?? '',
      targetCurrency: json['target_code'] ?? '',
      rate: (json['conversion_rate'] as num?)?.toDouble() ?? 0.0,
      date: date,
      amount: inputAmount,
      result: (json['conversion_result'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CurrencyListModel {
  final Map<String, String> currencies;

  CurrencyListModel({required this.currencies});

  factory CurrencyListModel.fromJson(Map<String, dynamic> json) {
    final symbols = json['symbols'] as Map<String, dynamic>?;
    final Map<String, String> currencyMap = {};

    symbols?.forEach((key, value) {
      currencyMap[key] = value.toString();
    });

    return CurrencyListModel(currencies: currencyMap);
  }

  // For ExchangeRate-API format
  factory CurrencyListModel.fromExchangeRateJson(Map<String, dynamic> json) {
    final codes = json['supported_codes'] as List<dynamic>?;
    final Map<String, String> currencyMap = {};

    if (codes != null) {
      for (var code in codes) {
        if (code is List && code.length >= 2) {
          currencyMap[code[0].toString()] = code[1].toString();
        }
      }
    }

    return CurrencyListModel(currencies: currencyMap);
  }

  List<String> getCurrencyCodes() {
    return currencies.keys.toList()..sort();
  }

  String getCurrencyName(String code) {
    return currencies[code] ?? code;
  }
}
