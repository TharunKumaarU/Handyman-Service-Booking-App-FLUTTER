import 'package:flutter/material.dart';

class PaintingPage extends StatelessWidget {
  const PaintingPage({super.key});

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
              child: Image.asset('assets/painter_banner.png', fit: BoxFit.fill),
            ),
            const SizedBox(height: 16),
            const Text(
              'Painters',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Precision. Passion. Paint.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Off White / White Painting
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/off_white',
              imagePath: 'assets/off_white_paint.png',
              title: 'Off White / White Painting',
              price: 'Starts at AED 389',
              description: 'Perfect for a fresh, bright coat of color.',
            ),
            // Color Painting
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/colour_paint',
              imagePath: 'assets/color_paint.png',
              title: 'Color Painting',
              price: 'Starts at AED 439',
              description: 'Revitalize your walls with vibrant colors.',
            ),
            // Water Damage Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/water_damage',
              imagePath: 'assets/water_damage.png',
              title: 'Water Damage Repair',
              price: 'Starts at AED 89',
              description: 'Keep your walls safe from water damage.',
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
