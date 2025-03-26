import 'package:flutter/material.dart';

class MasonPage extends StatelessWidget {
  const MasonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with mason image
            SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.asset('assets/mason_banner.png', fit: BoxFit.fill),
            ),
            const SizedBox(height: 16),
            const Text(
              'Masons',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Craftsmanship. Strength. Perfection.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Mason Brickwork
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/mason_brick',
              imagePath: 'assets/mason_brick.png',
              title: 'Brickwork',
              price: 'Starts at AED 499',
              description:
                  'Durable and precise brick masonry to enhance structural aesthetics.',
            ),
            // Mason Concrete Work
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/mason_concret',
              imagePath: 'assets/mason_concrete.png',
              title: 'Concrete Work',
              price: 'Starts at AED 599',
              description:
                  'Expert concrete services ensuring solid, long-lasting foundations.',
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
                    const SizedBox(height: 4),
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
