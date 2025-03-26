import 'package:flutter/material.dart';

class CurtainInteriorPage extends StatelessWidget {
  const CurtainInteriorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with curtain image (NO text overlay)
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset('assets/curtain_banner.png', fit: BoxFit.fill),
            ),
            const SizedBox(height: 16),
            const Text(
              'Curtains',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Elegance. Comfort. Style.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Curtain Installation Service Card
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/cur_install',
              imagePath: 'assets/curtain_install.png',
              title: 'Curtain Installation',
              price: 'Starts at AED 499',
              description:
                  'Expert installation for a flawless window dressing experience.',
            ),
            // Curtain Home Office Service Card
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/cur_home_office',
              imagePath: 'assets/curtain_home_office.png',
              title: 'Curtain Home Office',
              price: 'Starts at AED 549',
              description:
                  'Enhance your workspace with custom-made curtains designed for home offices.',
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
                  Navigator.pushNamed(
                    context,
                    '/cur_home_office',
                    arguments: mobileKey,
                  );
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
