import 'package:flutter/material.dart';

class CeilingGypsumPage extends StatelessWidget {
  const CeilingGypsumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with ceiling gypsum image (NO text overlay)
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset(
                'assets/ceiling_gypsum_banner.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ceiling Gypsum',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Elevate your ceilings with perfection.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Ceiling Gypsum Installation
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ceiling_gyp_inst',
              imagePath: 'assets/ceiling_gyp_inst.png',
              title: 'Ceiling Gypsum Installation',
              price: 'Starts at AED 250',
              description:
                  'Expert installation for durable and elegant ceilings.',
            ),
            // Ceiling Gypsum Repair
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ceiling_gyp_repair',
              imagePath: 'assets/ceiling_gyp_repair.png',
              title: 'Ceiling Gypsum Repair',
              price: 'Starts at AED 199',
              description:
                  'Professional repair to restore and reinforce your ceiling.',
            ),
            // Ceiling Gypsum Mold Treatment
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/ceiling_gyp_mold',
              imagePath: 'assets/ceiling_gyp_mold.png',
              title: 'Ceiling Gypsum Mold Treatment',
              price: 'Starts at AED 150',
              description:
                  'Effective mold removal for a safer and cleaner ceiling.',
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
