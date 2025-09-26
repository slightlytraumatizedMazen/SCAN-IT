import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

/// -------------------- CONSTANTS & THEMING --------------------
class AppConstants {
  static const String appName = 'SCAN IT';
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 600);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);
}

class AppColors {
  static const Color primary = Color(0xFF48A4E7);
  static const Color primaryDark = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF6C63FF);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary, // ✅ fixed
    scaffoldBackgroundColor: AppColors.background, // ✅ fixed
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary), // ✅ fixed
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface, // ✅ use surface instead of undefined cardColor
      elevation: 4,
      shape: const RoundedRectangleBorder( // ✅ const-safe
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
class AppAssets {
  static const String logo = 'assets/logo1.png';
  static const String placeholder = 'assets/placeholder.png';
}



/// -------------------- UTILITY CLASSES --------------------
class NavigationService {
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: AppConstants.pageTransitionDuration,
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  static void navigateReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: AppConstants.pageTransitionDuration,
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

/// -------------------- DATA MODELS --------------------
class MenuItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final String description;

  const MenuItem({
    required this.title,
    required this.icon,
    required this.screen,
    required this.description,
  });
}

/// -------------------- SPLASH SCREEN --------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startApp();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  void _startApp() {
    Timer(AppConstants.splashDuration, () {
      NavigationService.navigateReplacement(context, const MainApp());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 20),
                _buildAppName(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      AppAssets.logo,
      width: 250,
      height: 250,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.photo_camera,
            size: 60,
            color: AppColors.primary,
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return Text(
      AppConstants.appName,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}

/// -------------------- MAIN APP STRUCTURE --------------------
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ScannerScreen(),
    MarketplaceScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: "Scanner",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: "Marketplace",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

/// -------------------- HOME SCREEN --------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SCAN IT"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: const _HomeGrid(),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications feature coming soon!')),
    );
  }

  void _showSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search feature coming soon!')),
    );
  }
}

class _HomeGrid extends StatelessWidget {
  const _HomeGrid();

  final List<MenuItem> _menuItems = const [
    MenuItem(
      title: "Scanner",
      icon: Icons.camera_alt,
      description: "3D scanning tools",
      screen: ScannerScreen(),
    ),
    MenuItem(
      title: "Tools",
      icon: Icons.build,
      description: "Processing utilities",
      screen: ToolsScreen(),
    ),
    MenuItem(
      title: "Virtual Shelf",
      icon: Icons.collections,
      description: "Your 3D model library",
      screen: ShelfScreen(),
    ),
    MenuItem(
      title: "AI Generator",
      icon: Icons.auto_awesome,
      description: "AI-powered creation",
      screen: AIModelScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          return _AnimatedMenuCard(menuItem: _menuItems[index]);
        },
      ),
    );
  }
}

/// -------------------- ANIMATED MENU CARD --------------------
class _AnimatedMenuCard extends StatefulWidget {
  final MenuItem menuItem;

  const _AnimatedMenuCard({required this.menuItem});

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.animationDuration,
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _handleTap(context),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.menuItem.icon,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.menuItem.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.menuItem.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    NavigationService.navigateTo(context, widget.menuItem.screen);
  }
}

/// -------------------- SCANNER SCREEN --------------------
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scanner")),
      body: const _ScannerGrid(),
    );
  }
}

class _ScannerGrid extends StatelessWidget {
  const _ScannerGrid();

  final List<MenuItem> _scannerOptions = const [
    MenuItem(
      title: "3D Selfie Mode",
      icon: Icons.face,
      description: "Face and body scanning",
      screen: SelfieScreen(),
    ),
    MenuItem(
      title: "AR Guided Capture",
      icon: Icons.camera,
      description: "AI-assisted scanning",
      screen: ARCaptureScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _scannerOptions.length,
        itemBuilder: (context, index) {
          return _AnimatedMenuCard(menuItem: _scannerOptions[index]);
        },
      ),
    );
  }
}

/// -------------------- TOOLS SCREEN --------------------
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tools")),
      body: const _ToolsGrid(),
    );
  }
}

class _ToolsGrid extends StatelessWidget {
  const _ToolsGrid();

  final List<MenuItem> _toolOptions = const [
    MenuItem(
      title: "Save / Export",
      icon: Icons.save,
      description: "Export in multiple formats",
      screen: ExportScreen(),
    ),
    MenuItem(
      title: "Post Processing",
      icon: Icons.tune,
      description: "Enhance your models",
      screen: PostProcessingScreen(),
    ),
    MenuItem(
      title: "View 3D Model",
      icon: Icons.view_in_ar,
      description: "Preview and inspect",
      screen: ViewModelScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _toolOptions.length,
        itemBuilder: (context, index) {
          return _AnimatedMenuCard(menuItem: _toolOptions[index]);
        },
      ),
    );
  }
}

/// -------------------- MARKETPLACE SCREEN --------------------
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "Marketplace",
      description: "Discover, buy, and sell 3D models in our integrated marketplace. Connect with creators worldwide.",
      icon: Icons.store,
    );
  }
}

/// -------------------- SETTINGS SCREEN --------------------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "Settings",
      description: "Customize your experience, manage devices, and configure application preferences.",
      icon: Icons.settings,
    );
  }
}

/// -------------------- FEATURE SCREENS --------------------
class SelfieScreen extends StatelessWidget {
  const SelfieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "3D Selfie Mode",
      description: "Capture detailed 3D scans of faces and bodies with advanced photogrammetry technology.",
      icon: Icons.face,
    );
  }
}

class ARCaptureScreen extends StatelessWidget {
  const ARCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "AR Guided Capture",
      description: "Use augmented reality guidance for perfect scans with AI-powered object recognition.",
      icon: Icons.camera,
    );
  }
}

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "Export Models",
      description: "Export your 3D models in various formats: OBJ, STL, GLTF, STEP, USDZ, and 3MF.",
      icon: Icons.save,
    );
  }
}

class PostProcessingScreen extends StatelessWidget {
  const PostProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "Post Processing",
      description: "Enhance your models with mesh smoothing, hole filling, and optimization tools.",
      icon: Icons.tune,
    );
  }
}

class ViewModelScreen extends StatelessWidget {
  const ViewModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "View 3D Model",
      description: "Preview your models in 3D viewer or AR environment with realistic rendering.",
      icon: Icons.view_in_ar,
    );
  }
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "Virtual Shelf",
      description: "Organize and manage your growing collection of 3D models with smart categorization.",
      icon: Icons.collections,
    );
  }
}

class AIModelScreen extends StatelessWidget {
  const AIModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: "AI Model Generator",
      description: "Generate stunning 3D models from text prompts using advanced AI algorithms.",
      icon: Icons.auto_awesome,
    );
  }
}

/// -------------------- REUSABLE FEATURE SCREEN --------------------
class FeatureScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}