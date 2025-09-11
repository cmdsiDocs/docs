import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database/pages_tbl.dart';
import 'screens/about_screen.dart';
import 'screens/api_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/documentation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/luvpark_screen.dart';
import 'screens/luvpark_spms_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  runApp(const CleverMindsApp());
}

class CleverMindsApp extends StatelessWidget {
  const CleverMindsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clever Minds Digital Solutions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue[800],
          elevation: 1,
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(),
    const AboutScreen(),
    const ApiScreen(),
    const DocumentationScreen(),
    const ContactScreen(),
  ];

  final LayerLink _apiLayerLink = LayerLink();
  final LayerLink _docsLayerLink = LayerLink();
  OverlayEntry? _apiOverlayEntry;
  OverlayEntry? _docsOverlayEntry;
  bool _isApiDropdownHovered = false;
  bool _isApiButtonHovered = false;
  bool _isDocsDropdownHovered = false;
  bool _isDocsButtonHovered = false;

  @override
  void dispose() {
    _removeApiOverlay();
    _removeDocsOverlay();
    super.dispose();
  }

  bool get _shouldShowApiDropdown =>
      _isApiButtonHovered || _isApiDropdownHovered;
  bool get _shouldShowDocsDropdown =>
      _isDocsButtonHovered || _isDocsDropdownHovered;

  void _updateApiOverlay() {
    if (_shouldShowApiDropdown && _apiOverlayEntry == null) {
      _showApiOverlay();
    } else if (!_shouldShowApiDropdown && _apiOverlayEntry != null) {
      _removeApiOverlay();
    }
  }

  void _updateDocsOverlay() {
    if (_shouldShowDocsDropdown && _docsOverlayEntry == null) {
      _showDocsOverlay();
    } else if (!_shouldShowDocsDropdown && _docsOverlayEntry != null) {
      _removeDocsOverlay();
    }
  }

  void _removeApiOverlay() {
    _apiOverlayEntry?.remove();
    _apiOverlayEntry = null;
    _isApiDropdownHovered = false;
  }

  void _removeDocsOverlay() {
    _docsOverlayEntry?.remove();
    _docsOverlayEntry = null;
    _isDocsDropdownHovered = false;
  }

  Widget _buildDropdownMenuItem(String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          hoverColor: Colors.blue[200],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.grey[900],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showApiOverlay() {
    _apiOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 220, // menu width like Flutter.dev
        child: CompositedTransformFollower(
          link: _apiLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 0),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isApiDropdownHovered = true),
            onExit: (_) {
              setState(() {
                _isApiDropdownHovered = false;
                _updateApiOverlay();
              });
            },
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // 👈 makes height fit content
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDropdownMenuItem(
                          'API Documentation',
                          () {
                            _removeApiOverlay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ApiScreen(),
                              ),
                            );
                          },
                        ),
                        _buildDropdownMenuItem(
                          'API Examples',
                          () {
                            _removeApiOverlay();
                          },
                        ),
                        _buildDropdownMenuItem(
                          'API Reference',
                          () {
                            _removeApiOverlay();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_apiOverlayEntry!);
  }

  void _showDocsOverlay() {
    _docsOverlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 220,
        child: CompositedTransformFollower(
          link: _docsLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 0),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isDocsDropdownHovered = true),
            onExit: (_) {
              setState(() {
                _isDocsDropdownHovered = false;
                _updateDocsOverlay();
              });
            },
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDropdownMenuItem(
                          'LuvPark',
                          () {
                            _removeDocsOverlay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LuvParkScreen()),
                            );
                          },
                        ),
                        _buildDropdownMenuItem(
                          'LuvPark SPMS',
                          () {
                            _removeDocsOverlay();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LuvParkSpmsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_docsOverlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: isWideScreen ? _buildDesktopAppBar() : null,
      body: _screens[_currentIndex],
      bottomNavigationBar: isWideScreen ? null : _buildMobileNavigation(),
      drawer: !isWideScreen ? _buildMobileDrawer() : null,
    );
  }

  AppBar _buildDesktopAppBar() {
    return AppBar(
      title: Row(
        children: [
          InkWell(
            onTap: () => setState(() => _currentIndex = 0),
            child: Row(
              children: [
                Center(
                  child: Image.asset('assets/images/logo.png',
                      width: 24, height: 24),
                ),
                const SizedBox(width: 10),
                Text(
                  'Clever Minds',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue[800],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  style: TextButton.styleFrom(
                    foregroundColor: _currentIndex == 1
                        ? Colors.blue[800]
                        : Colors.grey[600],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'About Us',
                    style: GoogleFonts.poppins(
                      fontWeight: _currentIndex == 1
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isApiButtonHovered = true;
                    _updateApiOverlay();
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isApiButtonHovered = false;
                    _updateApiOverlay();
                  });
                },
                child: CompositedTransformTarget(
                  link: _apiLayerLink,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ApiScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _currentIndex == 2
                            ? Colors.blue[800]
                            : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'APIs',
                        style: GoogleFonts.poppins(
                          fontWeight: _currentIndex == 2
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _isDocsButtonHovered = true;
                    _updateDocsOverlay();
                  });
                },
                onExit: (_) {
                  setState(() {
                    _isDocsButtonHovered = false;
                    _updateDocsOverlay();
                  });
                },
                child: CompositedTransformTarget(
                  link: _docsLayerLink,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DocumentationScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: _currentIndex == 3
                            ? Colors.blue[800]
                            : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'Documentation',
                        style: GoogleFonts.poppins(
                          fontWeight: _currentIndex == 3
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () => setState(() => _currentIndex = 4),
                  style: TextButton.styleFrom(
                    foregroundColor: _currentIndex == 4
                        ? Colors.blue[800]
                        : Colors.grey[600],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Contact Us',
                    style: GoogleFonts.poppins(
                      fontWeight: _currentIndex == 4
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Get Started',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.api),
          label: 'APIs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description),
          label: 'Docs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.contact_mail),
          label: 'Contact',
        ),
      ],
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'CM',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Clever Minds',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Digital Solutions',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: _currentIndex == 0 ? Colors.blue[800] : Colors.grey[600],
            ),
            title: Text(
              'About Us',
              style: GoogleFonts.poppins(
                color: _currentIndex == 0 ? Colors.blue[800] : Colors.grey[600],
                fontWeight:
                    _currentIndex == 0 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            onTap: () {
              setState(() => _currentIndex = 0);
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            showTrailingIcon: false,
            leading: Icon(
              Icons.api,
              color: Colors.grey[600],
            ),
            title: Text(
              'API',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
              ),
            ),
            children: [
              _buildMobileApiItem('API Documentation', Icons.description, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ApiScreen()),
                );
              }),
              _buildMobileApiItem('API Examples', Icons.code, () {
                Navigator.pop(context);
              }),
              _buildMobileApiItem('API Reference', Icons.menu_book, () {
                Navigator.pop(context);
              }),
            ],
          ),
          ExpansionTile(
            leading: Icon(
              Icons.description,
              color: _currentIndex == 1 ? Colors.blue[800] : Colors.grey[600],
            ),
            title: Text(
              'Documentation',
              style: GoogleFonts.poppins(
                color: _currentIndex == 1 ? Colors.blue[800] : Colors.grey[600],
                fontWeight:
                    _currentIndex == 1 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            children: [
              _buildMobileDocsItem('LuvPark', Icons.local_parking, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LuvParkScreen()),
                );
              }),
              _buildMobileDocsItem('LuvPark SPMS', Icons.security, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LuvParkSpmsScreen()),
                );
              }),
            ],
          ),
          ListTile(
            leading: Icon(
              Icons.contact_mail,
              color: _currentIndex == 2 ? Colors.blue[800] : Colors.grey[600],
            ),
            title: Text(
              'Contact Us',
              style: GoogleFonts.poppins(
                color: _currentIndex == 2 ? Colors.blue[800] : Colors.grey[600],
                fontWeight:
                    _currentIndex == 2 ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            onTap: () {
              setState(() => _currentIndex = 2);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: Text(
              'Get Started',
              style: GoogleFonts.poppins(
                color: Colors.blue[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMobileApiItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.blue[700]),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildMobileDocsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.blue[700]),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
      onTap: onTap,
    );
  }
}
