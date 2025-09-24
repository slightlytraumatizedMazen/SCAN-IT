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
      title: 'SCAN IT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF48A4E7)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Start with Splash
    );
  }
}

/// ---------------- SPLASH SCREEN ----------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainApp()),
      );
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
      backgroundColor: const Color(0xFF48A4E7),
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/my_new_logo.png',  // <-- your new logo
                  fit: BoxFit.contain
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------- MAIN APP WITH BOTTOM NAV ----------------
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ScannerScreen(),
    const MarketplaceScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF48A4E7),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Scanner"),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Marketplace"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

/// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> menu = [
      _MenuItem("Scanner", Icons.camera, const ScannerScreen()),
      _MenuItem("Tools", Icons.build, const ToolsScreen()),
      _MenuItem("Virtual Shelf", Icons.collections, const ShelfScreen()),
      _MenuItem("AI Model Generator", Icons.auto_fix_high, const AIModelScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("SCAN IT"),
        backgroundColor: const Color(0xFF48A4E7),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return _AnimatedMenuCard(menuItem: menu[index]);
        },
      ),
    );
  }
}

/// ---------------- ANIMATED MENU CARD ----------------
class _AnimatedMenuCard extends StatefulWidget {
  final _MenuItem menuItem;
  const _AnimatedMenuCard({required this.menuItem});

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => widget.menuItem.screen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: () => _navigate(context),
          child: Card(
            color: Colors.deepPurple.shade50,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.menuItem.title,
                  child: Icon(widget.menuItem.icon,
                      size: 40, color: const Color(0xFF48A4E7)),
                ),
                const SizedBox(height: 10),
                Text(widget.menuItem.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------- SCANNER SCREEN ----------------
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> scannerOptions = [
      _MenuItem("3D Selfie Mode", Icons.face, const SelfieScreen()),
      _MenuItem("AR Guided Capture", Icons.camera, const ARCaptureScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Scanner"), backgroundColor: const Color(0xFF48A4E7)),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: scannerOptions.length,
        itemBuilder: (context, index) {
          return _AnimatedMenuCard(menuItem: scannerOptions[index]);
        },
      ),
    );
  }
}

/// ---------------- TOOLS SCREEN ----------------
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_MenuItem> toolOptions = [
      _MenuItem("Save / Export Model", Icons.save, const ExportScreen()),
      _MenuItem("Post Processing", Icons.build, const PostProcessingScreen()),
      _MenuItem("View 3D Model", Icons.view_in_ar, const ViewModelScreen()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Tools"), backgroundColor: const Color(0xFF48A4E7)),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: toolOptions.length,
        itemBuilder: (context, index) {
          return _AnimatedMenuCard(menuItem: toolOptions[index]);
        },
      ),
    );
  }
}

/// ---------------- MARKETPLACE & SETTINGS ----------------
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(
      title: "Marketplace",
      description: "Buy / Sell 3D models.\nIntegrated with Cloud services.",
      iconTag: "Marketplace",
      icon: Icons.store,
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimpleScreen(
      title: "Settings",
      description: "Manage device connection, preferences, About app.",
      iconTag: "Settings",
      icon: Icons.settings,
    );
  }
}

/// ---------------- EXTRA FEATURE SCREENS ----------------
class SelfieScreen extends StatelessWidget {
  const SelfieScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "3D Selfie Mode",
        description: "Face Scan / Body Scan",
        iconTag: "3D Selfie Mode",
        icon: Icons.face,
      );
}

class ARCaptureScreen extends StatelessWidget {
  const ARCaptureScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "AR Guided Capture",
        description: "AR capture with AI object masking.",
        iconTag: "AR Guided Capture",
        icon: Icons.camera,
      );
}

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "Export Model",
        description: "Export as OBJ, STL, GLTF, STEP, USDZ, 3MF with hole filling.",
        iconTag: "Export Model",
        icon: Icons.save,
      );
}

class PostProcessingScreen extends StatelessWidget {
  const PostProcessingScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "Post Processing",
        description: "Mesh smoothing & hole filling.",
        iconTag: "Post Processing",
        icon: Icons.build,
      );
}

class ViewModelScreen extends StatelessWidget {
  const ViewModelScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "View 3D Model",
        description: "Preview in 3D or AR environment.",
        iconTag: "View 3D Model",
        icon: Icons.view_in_ar,
      );
}

class ShelfScreen extends StatelessWidget {
  const ShelfScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "Virtual Collection Shelf",
        description: "Organize your saved 3D models.",
        iconTag: "Virtual Collection Shelf",
        icon: Icons.collections,
      );
}

class AIModelScreen extends StatelessWidget {
  const AIModelScreen({super.key});
  @override
  Widget build(BuildContext context) => _SimpleScreen(
        title: "AI Model Generator",
        description: "Generate 3D models from text prompts using AI.",
        iconTag: "AI Model Generator",
        icon: Icons.auto_fix_high,
      );
}

/// ---------------- REUSABLE SIMPLE PAGE ----------------
class _SimpleScreen extends StatelessWidget {
  final String title;
  final String description;
  final String iconTag;
  final IconData icon;

  const _SimpleScreen({
    required this.title,
    required this.description,
    required this.iconTag,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF48A4E7)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(tag: title, child: Icon(icon, size: 100, color: const Color(0xFF48A4E7))),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(description,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------- MENU ITEM CLASS ----------------
class _MenuItem {
  final String title;
  final IconData icon;
  final Widget screen;
  _MenuItem(this.title, this.icon, this.screen);
}
