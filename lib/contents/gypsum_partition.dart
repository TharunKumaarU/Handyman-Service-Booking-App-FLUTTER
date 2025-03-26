import 'package:flutter/material.dart';

class GypsumPartitionPage extends StatelessWidget {
  const GypsumPartitionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner (update asset if needed)
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset(
                'assets/gypsum_partition_banner.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Gypsum Partition',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Quality. Craftsmanship. Creativity.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Gypsum Part Installation
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/gypsum_part_installation',
              imagePath: 'assets/gypsum_installation.png',
              title: 'Gypsum Part Installation',
              price: 'Starts at AED 299',
              description:
                  'Expert installation for a flawless gypsum partition.',
            ),
            // Gypsum Part Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/gypsum_part_repair',
              imagePath: 'assets/gypsum_repair.png',
              title: 'Gypsum Part Repair',
              price: 'Starts at AED 199',
              description:
                  'Reliable repair services to restore your gypsum partition.',
            ),
            // Gypsum Part Customization
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/gypsum_part_custom',
              imagePath: 'assets/gypsum_custom.png',
              title: 'Gypsum Part Customization',
              price: 'Starts at AED 399',
              description: 'Tailor-made gypsum designs to elevate your space.',
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
