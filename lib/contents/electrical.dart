import 'package:flutter/material.dart';

class ElectricalPage extends StatelessWidget {
  const ElectricalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with electrical image
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset(
                'assets/electrical_banner.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Electricians',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Reliable. Safe. Efficient.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Book 4-30 Minutes Service
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ele_book_4_30mints',
              imagePath: 'assets/ele_Book_4_30mints.png',
              title: 'Book 4-30 Minutes Service',
              price: 'Starts at AED 99',
              description: 'Quick fixes for small electrical issues.',
            ),
            // Book Hourly Service
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ele_book_hrly',
              imagePath: 'assets/ele_Book_hrly.png',
              title: 'Book Hourly Service',
              price: 'Starts at AED 199',
              description: 'Hourly service for extensive electrical issues.',
            ),
            // TV Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ele_tv',
              imagePath: 'assets/ele_tv.png',
              title: 'TV Repair',
              price: 'Starts at AED 149',
              description: 'Expert repair services for your TV.',
            ),
            // Switch Replacement
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ele_switch',
              imagePath: 'assets/ele_switch.png',
              title: 'Switch Replacement',
              price: 'Starts at AED 79',
              description: 'Safe and reliable switch replacement.',
            ),
            // Wiring Solutions
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ele_wire',
              imagePath: 'assets/ele_wire.png',
              title: 'Wiring Solutions',
              price: 'Starts at AED 249',
              description: 'Professional wiring and electrical solutions.',
            ),
            // Bulb Replacement
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ele_bulb',
              imagePath: 'assets/ele_bulb.png',
              title: 'Bulb Replacement',
              price: 'Starts at AED 29',
              description: 'Quick and efficient bulb replacement service.',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String? mobileKey,
    required String routeName,
    required String imagePath,
    required String title,
    required String price,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Service Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Text Info (title, price, description)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // ADD Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, routeName, arguments: mobileKey);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('ADD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
