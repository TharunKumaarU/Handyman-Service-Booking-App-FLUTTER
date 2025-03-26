import 'package:flutter/material.dart';

class PlumberPage extends StatelessWidget {
  const PlumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with plumber image (NO text overlay)
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset('assets/plumber_banner.png', fit: BoxFit.fill),
            ),
            const SizedBox(height: 16),
            const Text(
              'Plumbers',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Reliable. Ready. Rapid.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Emergency Plumbing (4-30 mins response)
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/plumb_book_4_30mints',
              imagePath: 'assets/plumb_book_4_30mints.png',
              title: 'Emergency Plumbing (4-30 mins response)',
              price: 'Starts at AED 199',
              description:
                  'Swift emergency plumbing service for urgent repairs.',
            ),
            // Hourly Plumbing Service
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/plumb_book_hrly',
              imagePath: 'assets/plumb_book_hrly.png',
              title: 'Hourly Plumbing Service',
              price: 'Starts at AED 99',
              description:
                  'Flexible hourly service for all your plumbing needs.',
            ),
            // Blocked Drain Service
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/plumb_blk_drain',
              imagePath: 'assets/plumb_blk_drain.png',
              title: 'Blocked Drain Service',
              price: 'Starts at AED 149',
              description:
                  'Efficient unblocking solutions to restore proper flow.',
            ),
            // Leakage Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/plumb_leakage',
              imagePath: 'assets/plumb_leakage.png',
              title: 'Leakage Repair',
              price: 'Starts at AED 129',
              description: 'Reliable repairs for all leakage issues.',
            ),
            // Toilet Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/plumb_toilet',
              imagePath: 'assets/plumb_toilet.png',
              title: 'Toilet Repair',
              price: 'Starts at AED 109',
              description: 'Quick fixes for toilet malfunctions and clogs.',
            ),
            // Tap Installation & Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/plumb_tap',
              imagePath: 'assets/plumb_tap.png',
              title: 'Tap Installation & Repair',
              price: 'Starts at AED 89',
              description:
                  'Quality installation and repair for taps and fixtures.',
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
