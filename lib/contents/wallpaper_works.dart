import 'package:flutter/material.dart';

class WallpaperWorksPage extends StatelessWidget {
  const WallpaperWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileKey = ModalRoute.of(context)?.settings.arguments as String?;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top banner with wallpaper image (NO text overlay)
            SizedBox(
              height: size.height * 0.35,
              width: double.infinity,
              child: Image.asset(
                'assets/wallpaper_banner.png',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Wallpaper Works',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Expert Installation, Removal, and Repair',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // Wallpaper Installation Service Card
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/wallpaper_installation',
              imagePath: 'assets/wallpaper_installation.png',
              title: 'Wallpaper Installation',
              price: 'Starts at AED 399',
              description: 'Professional installation for a flawless finish.',
            ),
            // Wallpaper Removal Service Card
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/wallpaper_removal',
              imagePath: 'assets/wallpaper_removal.png',
              title: 'Wallpaper Removal',
              price: 'Starts at AED 299',
              description: 'Safe and efficient removal of old wallpaper.',
            ),
            // Wallpaper Repair Service Card
            _buildServiceCard(
              context: context,
              mobileKey: mobileKey,
              routeName: '/wallpaper_repair',
              imagePath: 'assets/wallpaper_repair.png',
              title: 'Wallpaper Repair',
              price: 'Starts at AED 389',
              description: 'Restore damaged wallpaper to perfection.',
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
