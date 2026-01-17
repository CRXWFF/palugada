import 'package:flutter/material.dart';
import '../widgets/weather_widget.dart';
import '../widgets/menu_card.dart';
import 'news_screen.dart';
import 'stock_screen.dart';
import 'currency_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Palugada',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weather Widget
            const WeatherWidget(),

            const SizedBox(height: 24),

            // Section Title
            const Text(
              'Menu Layanan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 16),

            // Menu Grid - 2 columns
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                MenuCard(
                  icon: Icons.newspaper,
                  title: 'Berita',
                  subtitle: 'Berita terkini',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewsScreen(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.show_chart,
                  title: 'Saham',
                  subtitle: 'Informasi saham US',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StockScreen(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.currency_exchange,
                  title: 'Kurs Mata Uang',
                  subtitle: 'Konversi valuta',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CurrencyScreen(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.settings,
                  title: 'Pengaturan',
                  subtitle: 'Atur preferensi',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur pengaturan akan segera hadir'),
                        backgroundColor: Colors.black87,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Info Footer
            Center(
              child: Text(
                'Aplikasi Serbaguna v0.0.01',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
