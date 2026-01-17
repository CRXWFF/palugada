import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../models/currency_model.dart';
import '../services/currency_service.dart';
import 'package:intl/intl.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final CurrencyService _currencyService = CurrencyService();
  final TextEditingController _amountController = TextEditingController(
    text: '1',
  );

  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  CurrencyModel? _conversionResult;
  CurrencyListModel? _currencyList;
  bool _isLoading = false;
  bool _isLoadingCurrencies = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
    _performConversion();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoadingCurrencies = true;
    });

    final currencies = await _currencyService.getSupportedCurrencies();

    setState(() {
      _currencyList = currencies;
      _isLoadingCurrencies = false;
    });
  }

  Future<void> _performConversion() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Masukkan jumlah yang valid';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _currencyService.convertCurrency(
        from: _fromCurrency,
        to: _toCurrency,
        amount: amount,
      );

      setState(() {
        _conversionResult = result;
        _isLoading = false;
        if (result == null) {
          _errorMessage = 'Gagal mengkonversi mata uang. Periksa API key Anda.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
    _performConversion();
  }

  void _showCurrencyPicker({required bool isFromCurrency}) async {
    if (_currencyList == null) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Pilih Mata Uang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _currencyList!.getCurrencyCodes().length,
                  itemBuilder: (context, index) {
                    final code = _currencyList!.getCurrencyCodes()[index];
                    final name = _currencyList!.getCurrencyName(code);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          code.substring(0, 1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      title: Text(
                        code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        name,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      onTap: () => Navigator.pop(context, code),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        if (isFromCurrency) {
          _fromCurrency = selected;
        } else {
          _toCurrency = selected;
        }
      });
      _performConversion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Konversi Mata Uang',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Input
            Card(
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
                    Text(
                      'Jumlah',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _performConversion,
                          color: Colors.black87,
                        ),
                      ),
                      onSubmitted: (_) => _performConversion(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // From Currency
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              child: InkWell(
                onTap: _isLoadingCurrencies
                    ? null
                    : () => _showCurrencyPicker(isFromCurrency: true),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dari',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _fromCurrency,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (_currencyList != null)
                              Text(
                                _currencyList!.getCurrencyName(_fromCurrency),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Swap Button
            Center(
              child: IconButton(
                onPressed: _swapCurrencies,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // To Currency
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              child: InkWell(
                onTap: _isLoadingCurrencies
                    ? null
                    : () => _showCurrencyPicker(isFromCurrency: false),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ke',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _toCurrency,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            if (_currencyList != null)
                              Text(
                                _currencyList!.getCurrencyName(_toCurrency),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Result
            Skeletonizer(
              enabled: _isLoading,
              child: _errorMessage != null
                  ? Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red[300]!, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[700],
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[100]!, Colors.grey[200]!],
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Hasil Konversi',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${formatter.format(_conversionResult?.result ?? 125000)} $_toCurrency',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '1 $_fromCurrency = ${formatter.format(_conversionResult?.rate ?? 15000)} $_toCurrency',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_conversionResult != null) ...[
                              const SizedBox(height: 12),
                              Divider(color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text(
                                'Terakhir diperbarui: ${DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(_conversionResult!.date)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // Convert Button
            ElevatedButton(
              onPressed: _isLoading ? null : _performConversion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Konversi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
