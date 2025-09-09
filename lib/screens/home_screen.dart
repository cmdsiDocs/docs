// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/project_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 800;
    final isVeryWideScreen = screenWidth > 1200;

    final bool hasAppBar = MediaQuery.of(context).size.width > 768;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: hasAppBar ? 180 : 200,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              image: const DecorationImage(
                image: AssetImage('assets/images/hero_background.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Clever Minds Digital Solutions, Inc.',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 48 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Transforming Ideas into Digital Reality',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 24 : 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),

          // Mission Section
          SectionHeader(
            title: 'Our Mission',
            subtitle: 'What drives us every day',
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: 40,
              horizontal: isVeryWideScreen
                  ? 120
                  : isWideScreen
                      ? 60
                      : 20,
            ),
            child: Text(
              'To empower businesses with innovative digital solutions that drive growth, '
              'enhance efficiency, and create meaningful connections with their audience. '
              'We believe in the power of technology to transform ideas into reality.',
              style: GoogleFonts.poppins(fontSize: 18, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),

          // Vision Section
          SectionHeader(title: 'Our Vision', subtitle: 'Where we\'re headed'),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(
              vertical: 40,
              horizontal: isVeryWideScreen
                  ? 120
                  : isWideScreen
                      ? 60
                      : 20,
            ),
            child: Text(
              'To be the leading digital solutions provider known for creativity, '
              'technical excellence, and unwavering commitment to client success. '
              'We envision a future where every business can leverage cutting-edge '
              'technology to achieve their dreams.',
              style: GoogleFonts.poppins(fontSize: 18, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),

          // Projects Section - Using your actual assets
          SectionHeader(
            title: 'Featured Projects',
            subtitle: 'Our latest work',
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                ProjectCard(
                  title: 'E-Commerce Platform',
                  description: 'Modern online shopping experience',
                  imagePath: 'assets/images/ecommerce.jpg',
                ),
                ProjectCard(
                  title: 'Mobile Banking App',
                  description: 'Secure financial management',
                  imagePath: 'assets/images/banking.jpg',
                ),
                ProjectCard(
                  title: 'Healthcare Dashboard',
                  description: 'Patient data visualization',
                  imagePath: 'assets/images/healthcare.jpg',
                ),
              ],
            ),
          ),

          // Stats Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60),
            color: Colors.grey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('200+', 'Projects Completed'),
                _buildStat('50+', 'Happy Clients'),
                _buildStat('15+', 'Years Experience'),
                _buildStat('99%', 'Client Satisfaction'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
