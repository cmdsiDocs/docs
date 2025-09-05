// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/about_screen.dart';
import 'screens/api_screen.dart'; // New
import 'screens/contact_screen.dart';
import 'screens/documentation_screen.dart'; // New
// main.dart (imports section)
import 'screens/home_screen.dart';

void main() {
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

  final List<String> _tabTitles = [
    'Home',
    'About Us',
    'API',
    'Documentation',
    'Contact Us'
  ];

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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'CM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
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
          const Spacer(),
          Row(
            children: List.generate(_tabTitles.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextButton(
                  onPressed: () => setState(() => _currentIndex = index),
                  style: TextButton.styleFrom(
                    foregroundColor: _currentIndex == index
                        ? Colors.blue[800]
                        : Colors.grey[600],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    _tabTitles[index],
                    style: GoogleFonts.poppins(
                      fontWeight: _currentIndex == index
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
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
            ),
            child: const Text('Get Started'),
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
          label: 'API',
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
          ...List.generate(_tabTitles.length, (index) {
            return ListTile(
              leading: Icon(
                _getIconForIndex(index),
                color: _currentIndex == index
                    ? Colors.blue[800]
                    : Colors.grey[600],
              ),
              title: Text(
                _tabTitles[index],
                style: GoogleFonts.poppins(
                  color: _currentIndex == index
                      ? Colors.blue[800]
                      : Colors.grey[600],
                  fontWeight: _currentIndex == index
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() => _currentIndex = index);
                Navigator.pop(context);
              },
            );
          }),
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

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.info;
      case 2:
        return Icons.api;
      case 3:
        return Icons.description;
      case 4:
        return Icons.contact_mail;
      default:
        return Icons.home;
    }
  }
}
