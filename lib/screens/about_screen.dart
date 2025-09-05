// screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'About Clever Minds',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Innovation meets excellence in digital solutions',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),

          // Company Story
          _buildSection(
            'Our Story',
            'Founded in 2010, Clever Minds Digital Solutions has been at the forefront '
                'of digital innovation. What started as a small team of passionate developers '
                'has grown into a full-service digital agency serving clients worldwide.',
          ),

          // Team Section
          _buildTeamSection(),

          // Values Section
          _buildValuesSection(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 15),
          Text(content, style: GoogleFonts.poppins(fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Team',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildTeamMember('John Doe', 'CEO & Founder', 'assets/ceo.jpg'),
              _buildTeamMember('Jane Smith', 'CTO', 'assets/cto.jpg'),
              _buildTeamMember(
                'Mike Johnson',
                'Lead Developer',
                'assets/lead.jpg',
              ),
              _buildTeamMember(
                'Sarah Wilson',
                'Design Director',
                'assets/designer.jpg',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String imageUrl) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(radius: 50, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(height: 15),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(role, style: GoogleFonts.poppins(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildValuesSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Values',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            'Innovation',
            'We constantly push boundaries and explore new technologies',
          ),
          _buildValueItem(
            'Excellence',
            'We deliver nothing but the highest quality work',
          ),
          _buildValueItem(
            'Integrity',
            'We believe in honesty and transparency in all we do',
          ),
          _buildValueItem(
            'Collaboration',
            'We work together with our clients as partners',
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(String title, String description) {
    return ListTile(
      leading: Icon(Icons.star, color: Colors.blue[800]),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}
