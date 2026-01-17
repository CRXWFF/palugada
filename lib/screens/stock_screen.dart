import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/stock_model.dart';
import '../services/stock_service.dart';
import 'package:intl/intl.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final StockService _stockService = StockService();
  List<StockModel> _stocks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  // Popular stocks
  final List<String> _defaultSymbols = [
    'AAPL', // Apple
    'GOOGL', // Google
    'MSFT', // Microsoft
    'TSLA', // Tesla
    'AMZN', // Amazon
  ];

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  Future<void> _loadStocks() async {
    setState(() {
      _isLoading = true;
    });

    final stocks = await _stockService.getStockQuotes(_defaultSymbols);

    setState(() {
      _stocks = stocks;
      _isLoading = false;
    });
  }

  Future<void> _searchStock(String symbol) async {
    if (symbol.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final stock = await _stockService.getSingleStock(symbol.toUpperCase());

    setState(() {
      if (stock != null) {
        _stocks = [stock];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simbol saham tidak ditemukan'),
            backgroundColor: Colors.red,
          ),
        );
      }
      _isLoading = false;
    });
  }

  StockModel _getDummyStock() {
    return StockModel(
      ticker: 'LOAD',
      name: 'Loading Stock Company Name Placeholder',
      price: 150.50,
      change: 2.50,
      changePercent: 1.69,
      volume: 1000000,
      dayHigh: 152.00,
      dayLow: 148.00,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Informasi Saham US',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari simbol saham (contoh: AAPL)',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onSubmitted: _searchStock,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _searchStock(_searchController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cari'),
                ),
              ],
            ),
          ),

          // Popular Stocks Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Saham Populer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _loadStocks,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh'),
                  style: TextButton.styleFrom(foregroundColor: Colors.black87),
                ),
              ],
            ),
          ),

          // Stock List
          Expanded(
            child: Skeletonizer(
              enabled: _isLoading,
              child: _stocks.isEmpty && !_isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.show_chart,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada data saham',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _loadStocks,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Muat Ulang'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadStocks,
                      color: Colors.black87,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _isLoading ? 5 : _stocks.length,
                        itemBuilder: (context, index) {
                          final stock = _isLoading
                              ? _getDummyStock()
                              : _stocks[index];
                          return _buildStockCard(stock);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCard(StockModel stock) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    final volumeFormatter = NumberFormat.compact();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticker & Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.ticker,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stock.name,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Price & Change
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${formatter.format(stock.price)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: stock.isPositive
                            ? Colors.green[50]
                            : Colors.red[50],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: stock.isPositive
                              ? Colors.green[700]!
                              : Colors.red[700]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            stock.isPositive
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 14,
                            color: stock.isPositive
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${stock.isPositive ? '+' : ''}${formatter.format(stock.change)} (${stock.changePercent.toStringAsFixed(2)}%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: stock.isPositive
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Divider
            Divider(color: Colors.grey[300], height: 1),

            const SizedBox(height: 16),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Tertinggi',
                    '\$${formatter.format(stock.dayHigh)}',
                    Icons.trending_up,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatItem(
                    'Terendah',
                    '\$${formatter.format(stock.dayLow)}',
                    Icons.trending_down,
                  ),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                Expanded(
                  child: _buildStatItem(
                    'Volume',
                    volumeFormatter.format(stock.volume),
                    Icons.bar_chart,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
