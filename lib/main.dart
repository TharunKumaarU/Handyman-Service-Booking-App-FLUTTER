import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// Pages
import 'pages/splash_screen.dart';
import 'pages/onboarding_1.dart';
import 'pages/onboarding_2.dart';
import 'pages/onboarding_3.dart';
import 'pages/login_page.dart';
import 'pages/address.dart';
import 'pages/slot.dart';
import 'pages/summary_page.dart';
import 'pages/payment.dart';
// Home & service pages
import 'contents/home.dart';
import 'contents/painting.dart';
import 'contents/wallpaper_works.dart';
import 'contents/ceiling_gypsum.dart';
import 'contents/gypsum_partition.dart';
import 'contents/tile_works.dart';
import 'contents/ac.dart';
import 'contents/plumber.dart';
import 'contents/electrical.dart';
import 'contents/cctv.dart';
import 'contents/mason.dart';
import 'contents/carpenter.dart';
import 'contents/furniture_fitting.dart';
import 'contents/curtain_interior.dart';
import 'contents/polish_sign.dart';
import 'contents/structure_frame.dart';
import 'contents/welding_fab.dart';
import 'contents/cleaning.dart';

// Sub-Contents (Painting)
import 'Sub-Contents/off_white.dart';
import 'Sub-Contents/color_paint.dart';
import 'Sub-Contents/water_damage.dart';
// Sub-Contents (Wallpaper)
import 'Sub-Contents/wallpaper_installation.dart';
import 'Sub-Contents/wallpaper_removal.dart';
import 'Sub-Contents/wallpaper_repair.dart';
// Sub-Contents (Ceiling Gypsum)
import 'Sub-Contents/ceiling_gyp_inst.dart';
import 'Sub-Contents/ceiling_gyp_repair.dart';
import 'Sub-Contents/ceiling_gyp_mold.dart';
// Sub-Contents (Gypsum Partition)
import 'Sub-Contents/gypsum_part_installation.dart';
import 'Sub-Contents/gypsum_part_repair.dart';
import 'Sub-Contents/gypsum_part_custom.dart';
// Sub-Contents (Tile Works)
import 'Sub-Contents/tile_install.dart';
import 'Sub-Contents/tile_repair.dart';
import 'Sub-Contents/tile_grout.dart';
// Sub-Contents (AC)
import 'Sub-Contents/ac_repair.dart';
import 'Sub-Contents/ac_duct.dart';
import 'Sub-Contents/ac_split.dart';
import 'Sub-Contents/ac_win.dart';
// Sub-Contents (Plumbing)
import 'Sub-Contents/plumb_book_4_30mints.dart';
import 'Sub-Contents/plumb_book_hrly.dart';
import 'Sub-Contents/plumb_blk_drain.dart';
import 'Sub-Contents/plumb_leakage.dart';
import 'Sub-Contents/plumb_toilet.dart';
import 'Sub-Contents/plumb_tap.dart';
// Sub-Contents (Electrical)
import 'Sub-Contents/ele_book_4_30mints.dart';
import 'Sub-Contents/ele_book_hrly.dart';
import 'Sub-Contents/ele_tv.dart';
import 'Sub-Contents/ele_switch.dart';
import 'Sub-Contents/ele_wire.dart';
import 'Sub-Contents/ele_bulb.dart';
// Sub-Contents for CCTV
import 'Sub-Contents/cctv_install.dart';
import 'Sub-Contents/cctv_repair.dart';
// Sub-Contents for Mason
import 'Sub-Contents/mason_brick.dart';
import 'Sub-Contents/mason_concret.dart';
// Sub-Contents for Carpenter
import 'Sub-Contents/car_fur_repair.dart';
import 'Sub-Contents/car_wood_install.dart';
import 'Sub-Contents/car_wood_work.dart';
// Sub-Contents for Furniture Fitting
import 'Sub-Contents/fur_install.dart';
import 'Sub-Contents/fur_repair.dart';
// Sub-Contents for Curtain Interior
import 'Sub-Contents/cur_home_office.dart';
import 'Sub-Contents/cur_install.dart';
// Sub-Contents for Polishing Signboard
import 'Sub-Contents/pol_sign.dart';
import 'Sub-Contents/pol_wood_furn.dart';
// Sub-Contents for Structure & Frame Works
import 'Sub-Contents/str_steel.dart';
import 'Sub-Contents/str_wood_roof.dart';
// Sub-Contents for Welding & Fabrication
import 'Sub-Contents/weld_steel.dart';
import 'Sub-Contents/weld_grill.dart';
// Sub-Contents for Cleaning Services
import 'Sub-Contents/clean_commercial.dart';
import 'Sub-Contents/clean_house.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51R4fnuKQWlEdAz5qdzwCNRnLFYpWZV8EXNnXJ0ihNUSFeHgTTnn9iB9WgIiPzzemaNDFAoj3m2HlgeoivhVvadjz00Jt8dCI3L';
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// Determines whether to show Splash/Login or go to Home based on FirebaseAuth state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const SplashScreen();
          } else {
            return const HomePage();
          }
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      title: 'Stripe Payment Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        // Onboarding / Auth
        '/splash': (context) => const SplashScreen(),
        '/onboarding1': (context) => const Onboarding1(),
        '/onboarding2': (context) => const Onboarding2(),
        '/onboarding3': (context) => const Onboarding3(),
        '/login': (context) => const LoginPage(),
        '/address': (context) => const AddressPage(),
        '/slot': (context) => const SlotPage(),
        '/summary_page': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;
          if (args is String && args.isNotEmpty) {
            return SummaryPage(mobileKey: args);
          } else if (args is Map<String, dynamic> &&
              args['mobileKey'] != null &&
              args['mobileKey'].toString().isNotEmpty) {
            return SummaryPage(mobileKey: args['mobileKey']);
          } else {
            return const Scaffold(
              body: Center(child: Text('Error: Mobile key is required')),
            );
          }
        },
        '/payment': (context) {
          // When navigating to PaymentPage, pass the total price as an argument.
          final totalPrice =
              ModalRoute.of(context)?.settings.arguments as double? ?? 0.0;
          return PaymentPage(totalPrice: totalPrice);
        },

        // Home & Services
        '/home': (context) => const HomePage(),
        '/painting': (context) => const PaintingPage(),
        '/wallpaper_works': (context) => const WallpaperWorksPage(),
        '/ceiling_gypsum': (context) => const CeilingGypsumPage(),
        '/gypsum_partition': (context) => const GypsumPartitionPage(),
        '/tile_works': (context) => const TileWorksPage(),
        '/ac': (context) => const AcPage(),
        '/plumbing': (context) => const PlumberPage(),
        '/electrical': (context) => const ElectricalPage(),
        '/cctv': (context) => const CctvPage(),
        '/manson': (context) => const MasonPage(),
        '/carpenter': (context) => const CarpenterPage(),
        '/furniture_fitting': (context) => const FurnitureFittingPage(),
        '/curtain_interior': (context) => const CurtainInteriorPage(),
        '/polish_sign': (context) => const PolishSignPage(),
        '/structure_frame': (context) => const StructureFramePage(),
        '/welding_fab': (context) => const WeldingFabPage(),
        '/cleaning': (context) => const CleaningPage(),
        // Painting Sub-Contents
        '/off_white': (context) => const OffWhitePage(),
        '/colour_paint': (context) => const ColorPaintingPage(),
        '/water_damage': (context) => const WaterDamagePage(),
        // Sub-Contents (Wallpaper)
        '/wallpaper_installation':
            (context) => const WallpaperInstallationPage(),
        '/wallpaper_removal': (context) => const WallpaperRemovalPage(),
        '/wallpaper_repair': (context) => const WallpaperRepairPage(),
        // Sub-Contents (Ceiling Gypsum)
        '/ceiling_gyp_inst': (context) => const CeilingGypInstPage(),
        '/ceiling_gyp_repair': (context) => const CeilingGypRepairPage(),
        '/ceiling_gyp_mold': (context) => const CeilingGypMoldPage(),
        // Sub-Contents (Gypsum Partition)
        '/gypsum_part_installation':
            (context) => const GypsumPartInstallationPage(),
        '/gypsum_part_repair': (context) => const GypsumPartRepairPage(),
        '/gypsum_part_custom': (context) => const GypsumPartCustomPage(),
        // Sub-Contents (Tile Works)
        '/tile_install': (context) => const TileInstallPage(),
        '/tile_repair': (context) => const TileRepairPage(),
        '/tile_grout': (context) => const TileGroutPage(),
        // Sub-Contents (AC)
        '/ac_repair': (context) => const AcRepairPage(),
        '/ac_duct': (context) => const AcDuctPage(),
        '/ac_split': (context) => const AcSplitPage(),
        '/ac_win': (context) => const AcWinPage(),
        // Sub-Contents (Plumbing)
        '/plumb_book_4_30mints': (context) => const PlumbBook430MintsPage(),
        '/plumb_book_hrly': (context) => const PlumbBookHrlyPage(),
        '/plumb_blk_drain': (context) => const PlumbBlkDrainPage(),
        '/plumb_leakage': (context) => const PlumbLeakagePage(),
        '/plumb_toilet': (context) => const PlumbToiletPage(),
        '/plumb_tap': (context) => const PlumbTapPage(),
        // Sub-Contents (Electrical)
        '/ele_book_4_30mints': (context) => const EleBook4MintsPage(),
        '/ele_book_hrly': (context) => const EleBookHrlyPage(),
        '/ele_tv': (context) => const EleTVPage(),
        '/ele_switch': (context) => const EleSwitchPage(),
        '/ele_wire': (context) => const EleWirePage(),
        '/ele_bulb': (context) => const EleBulbPage(),
        // CCTV Sub-Contents
        '/cctv_install': (context) => const CctvInstallPage(),
        '/cctv_repair': (context) => const CctvRepairPage(),
        // Mason sub-contents
        '/mason_brick': (context) => const MasonBrickPage(),
        '/mason_concret': (context) => const MasonConcretPage(),
        // Carpenter Sub-Contents
        '/car_fur_repair': (context) => const CarFurRepairPage(),
        '/car_wood_work': (context) => const CarWoodWorkPage(),
        '/car_wood_install': (context) => const CarWoodInstallPage(),
        // Furniture Fitting Sub-Contents
        '/fur_install': (context) => const FurInstallPage(),
        '/fur_repair': (context) => const FurRepairPage(),
        // Curtain Interior Sub-Contents
        '/cur_home_office': (context) => const CurtainHomeOfficePage(),
        '/cur_install': (context) => const CurtainInstallPage(),
        // Polish Signboard Sub-Contents
        '/pol_sign': (context) => const PolSignPage(),
        '/pol_wood_furn': (context) => const PolWoodFurnPage(),
        // Structure & Frame Works Sub-Contents
        '/str_steel': (context) => const StrSteelPage(),
        '/str_wood_roof': (context) => const StrWoodRoofPage(),
        // Welding & Fabrication Sub-Contents
        '/weld_steel': (context) => const WeldSteelPage(),
        '/weld_grill': (context) => const WeldGrillPage(),
        // Cleaning Services Sub-Contents
        '/clean_house': (context) => const CleanHousePage(),
        '/clean_commercial': (context) => const CleanCommercialPage(),
      },
    );
  }
}
