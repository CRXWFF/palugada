class StockModel {
  final String ticker;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final int volume;
  final double dayHigh;
  final double dayLow;

  StockModel({
    required this.ticker,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.volume,
    required this.dayHigh,
    required this.dayLow,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      ticker: json['ticker'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      change: (json['change'] as num?)?.toDouble() ?? 0.0,
      changePercent: (json['change_percent'] as num?)?.toDouble() ?? 0.0,
      volume: json['volume'] ?? 0,
      dayHigh: (json['day_high'] as num?)?.toDouble() ?? 0.0,
      dayLow: (json['day_low'] as num?)?.toDouble() ?? 0.0,
    );
  }

  bool get isPositive => change >= 0;
}
