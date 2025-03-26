import 'package:flutter/material.dart';

class AcPage extends StatelessWidget {
  const AcPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset('assets/ac_banner.png', fit: BoxFit.fill),
            ),
            const SizedBox(height: 16),
            const Text(
              'AC Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Keeping you cool with precision & care.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // AC Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ac_repair',
              imagePath: 'assets/ac_repair.png',
              title: 'AC Repair',
              price: 'Starts at AED 159',
              description:
                  'Professional repair services to restore your AC performance.',
            ),
            // AC Duct Cleaning
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ac_duct',
              imagePath: 'assets/ac_duct.png',
              title: 'AC Duct Cleaning',
              price: 'Starts at AED 199',
              description:
                  'Keep your air ducts clean for improved air quality and efficiency.',
            ),
            // AC Split Service
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ac_split',
              imagePath: 'assets/ac_split.png',
              title: 'AC Split Service',
              price: 'Starts at AED 179',
              description:
                  'Expert maintenance and repair for your split AC units.',
            ),
            // AC Window Service
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ac_win',
              imagePath: 'assets/ac_win.png',
              title: 'Window AC Service',
              price: 'Starts at AED 129',
              description:
                  'Efficient service for your window AC units to keep you cool.',
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
