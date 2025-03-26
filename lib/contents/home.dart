import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userLocation = "Fetching location...";
  String? mobileKey;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Keys for scrolling to sections
  final GlobalKey _homeImprovementKey = GlobalKey();
  final GlobalKey _repairMaintenanceKey = GlobalKey();
  final GlobalKey _furnitureInteriorKey = GlobalKey();
  final GlobalKey _constructionFabricationKey = GlobalKey();
  final GlobalKey _cleaningServicesKey = GlobalKey();

  bool _shouldShowDialog = false;
  String? _dialogTitle;
  String? _dialogMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the mobileKey from route arguments (passed from AddressPage or SlotPage)
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      mobileKey = args;
    }
    _fetchUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception("Location services are disabled.");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied");
      }
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String fetchedLocation = "";
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final List<String> addressComponents = [];
        if (placemark.thoroughfare != null &&
            placemark.thoroughfare!.isNotEmpty) {
          addressComponents.add(placemark.thoroughfare!);
        }
        if (placemark.subLocality != null &&
            placemark.subLocality!.isNotEmpty) {
          addressComponents.add(placemark.subLocality!);
        }
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          addressComponents.add(placemark.locality!);
        }
        fetchedLocation = addressComponents.join(", ");
      }
      if (!mounted) return;
      setState(() {
        userLocation =
            fetchedLocation.isNotEmpty
                ? fetchedLocation
                : "Location unavailable";
        if (!userLocation.toLowerCase().contains("dubai")) {
          _shouldShowDialog = true;
          _dialogTitle = "SORRY!!";
          _dialogMessage = "We are not available here";
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        userLocation = "Location unavailable";
      });
    }
  }

  void _scrollToSection(GlobalKey key) {
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  void _searchService(String query) {
    String searchQuery = query.toLowerCase();

    final List<Map<String, String>> homeImprovement = [
      {'name': 'Painting', 'image': 'painting.png', 'route': '/painting'},
      {
        'name': 'Wallpaper works',
        'image': 'wallpaper_works.png',
        'route': '/wallpaper_works',
      },
      {
        'name': 'Ceiling gypsum',
        'image': 'ceiling_gypsum.png',
        'route': '/ceiling_gypsum',
      },
      {
        'name': 'Gypsum partitions',
        'image': 'gypsum_partition.png',
        'route': '/gypsum_partition',
      },
      {'name': 'Tile works', 'image': 'tile_works.png', 'route': '/tile_works'},
    ];

    final List<Map<String, String>> repairMaintenance = [
      {'name': 'A/C works', 'image': 'ac.png', 'route': '/ac'},
      {'name': 'Plumbing', 'image': 'plumbing.png', 'route': '/plumbing'},
      {'name': 'Electrical', 'image': 'electrical.png', 'route': '/electrical'},
      {'name': 'CCTV Installation', 'image': 'cctv.png', 'route': '/cctv'},
      {'name': 'General mason', 'image': 'manson.png', 'route': '/manson'},
    ];

    final List<Map<String, String>> furnitureInterior = [
      {'name': 'Carpenter', 'image': 'carpenter.png', 'route': '/carpenter'},
      {
        'name': 'Furniture Fitting',
        'image': 'furniture_fitting.png',
        'route': '/furniture_fitting',
      },
      {
        'name': 'Curtain & Interior Decor',
        'image': 'curtain_interior.png',
        'route': '/curtain_interior',
      },
      {
        'name': 'Polish & Sign Board',
        'image': 'polish_sign.png',
        'route': '/polish_sign',
      },
    ];

    final List<Map<String, String>> constructionFabrication = [
      {
        'name': 'Structure & Frame Works',
        'image': 'structure_frame.png',
        'route': '/structure_frame',
      },
      {
        'name': 'Welding & Fabrication',
        'image': 'welding_fab.png',
        'route': '/welding_fab',
      },
    ];

    final List<Map<String, String>> cleaningServices = [
      {'name': 'Home Cleaning', 'image': 'cleaning.png', 'route': '/cleaning'},
    ];

    if (homeImprovement.any(
      (service) => service['name']!.toLowerCase().contains(searchQuery),
    )) {
      _scrollToSection(_homeImprovementKey);
    } else if (repairMaintenance.any(
      (service) => service['name']!.toLowerCase().contains(searchQuery),
    )) {
      _scrollToSection(_repairMaintenanceKey);
    } else if (furnitureInterior.any(
      (service) => service['name']!.toLowerCase().contains(searchQuery),
    )) {
      _scrollToSection(_furnitureInteriorKey);
    } else if (constructionFabrication.any(
      (service) => service['name']!.toLowerCase().contains(searchQuery),
    )) {
      _scrollToSection(_constructionFabricationKey);
    } else if (cleaningServices.any(
      (service) => service['name']!.toLowerCase().contains(searchQuery),
    )) {
      _scrollToSection(_cleaningServicesKey);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Service not found')));
    }
  }

  Widget _buildServiceSlider(List<Map<String, String>> services) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                service['route']!,
                arguments: mobileKey,
              );
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/${service['image']}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['name'] ?? "",
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If location not in Dubai, show a dialog after build.
    if (_shouldShowDialog && _dialogTitle != null && _dialogMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder:
              (dialogCtx) => AlertDialog(
                title: Text(_dialogTitle!),
                content: Text(_dialogMessage!),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (mounted) Navigator.of(dialogCtx).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
        setState(() => _shouldShowDialog = false);
      });
    }

    // Sample data for each section
    final List<Map<String, String>> homeImprovement = [
      {'name': 'Painting', 'image': 'painting.png', 'route': '/painting'},
      {
        'name': 'Wallpaper works',
        'image': 'wallpaper_works.png',
        'route': '/wallpaper_works',
      },
      {
        'name': 'Ceiling gypsum',
        'image': 'ceiling_gypsum.png',
        'route': '/ceiling_gypsum',
      },
      {
        'name': 'Gypsum partitions',
        'image': 'gypsum_partition.png',
        'route': '/gypsum_partition',
      },
      {'name': 'Tile works', 'image': 'tile_works.png', 'route': '/tile_works'},
    ];

    final List<Map<String, String>> repairMaintenance = [
      {'name': 'A/C works', 'image': 'ac.png', 'route': '/ac'},
      {'name': 'Plumbing', 'image': 'plumbing.png', 'route': '/plumbing'},
      {'name': 'Electrical', 'image': 'electrical.png', 'route': '/electrical'},
      {'name': 'CCTV Installation', 'image': 'cctv.png', 'route': '/cctv'},
      {'name': 'General mason', 'image': 'manson.png', 'route': '/manson'},
    ];

    final List<Map<String, String>> furnitureInterior = [
      {'name': 'Carpenter', 'image': 'carpenter.png', 'route': '/carpenter'},
      {
        'name': 'Furniture Fitting',
        'image': 'furniture_fitting.png',
        'route': '/furniture_fitting',
      },
      {
        'name': 'Curtain & Interior Decor',
        'image': 'curtain_interior.png',
        'route': '/curtain_interior',
      },
      {
        'name': 'Polish & Sign Board',
        'image': 'polish_sign.png',
        'route': '/polish_sign',
      },
    ];

    final List<Map<String, String>> constructionFabrication = [
      {
        'name': 'Structure & Frame Works',
        'image': 'structure_frame.png',
        'route': '/structure_frame',
      },
      {
        'name': 'Welding & Fabrication',
        'image': 'welding_fab.png',
        'route': '/welding_fab',
      },
    ];

    final List<Map<String, String>> cleaningServices = [
      {'name': 'Home Cleaning', 'image': 'cleaning.png', 'route': '/cleaning'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.black),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                userLocation,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              final nav = Navigator.of(context);
              FirebaseAuth.instance.signOut().then((_) {
                if (!mounted) return;
                nav.pushReplacementNamed('/login');
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hey User,",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "“Need A Fix? We’ve Got the Pros!\nHow can we help you today?”",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  onSubmitted: _searchService,
                  decoration: InputDecoration(
                    hintText: 'Search services',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFDFF4FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example promotional banner
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                "assets/promo_1.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 350,
              ),
            ),
            // Home Improvement
            Container(
              key: _homeImprovementKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Home Improvement",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildServiceSlider(homeImprovement),
                ],
              ),
            ),
            // Another banner
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                "assets/promo_2.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 350,
              ),
            ),
            // Repair & Maintenance
            Container(
              key: _repairMaintenanceKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Repair & Maintenance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildServiceSlider(repairMaintenance),
                ],
              ),
            ),
            // Another banner
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                "assets/promo_3.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 350,
              ),
            ),
            // Furniture & Interior
            Container(
              key: _furnitureInteriorKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Furniture and Interior",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildServiceSlider(furnitureInterior),
                ],
              ),
            ),
            // Construction & Fabrication
            Container(
              key: _constructionFabricationKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Construction & Fabrication",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildServiceSlider(constructionFabrication),
                ],
              ),
            ),
            // Cleaning Services
            Container(
              key: _cleaningServicesKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Cleaning Services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  _buildServiceSlider(cleaningServices),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
