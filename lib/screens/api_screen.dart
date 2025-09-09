// screens/api_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Reference',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Explore our RESTful API endpoints',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            // Authentication Section
            _buildApiSection(
              context,
              'Authentication',
              'Secure your API requests with JWT tokens',
              '''
## Base URLs
- **Production**: https://api.cleverminds.com/v1
- **Sandbox**: https://api-sandbox.cleverminds.com/v1

## Authentication
All API requests require authentication. Include your API key in the header:
''',
              '''
Authorization: Bearer YOUR_API_KEY
''',
              'http',
              '''
## Getting API Key
1. Sign up for an account
2. Go to Dashboard → API Settings
3. Generate your API key
''',
            ),

            // Users API
            _buildApiSection(
              context,
              'Users API',
              'Manage user accounts and profiles',
              '''
### Get User Profile
''',
              '''
GET /users/{id}
Authorization: Bearer <token>
''',
              'http',
              '''
**Response:**
''',
              '''
{
  "id": "user_123",
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2023-01-01T00:00:00Z",
  "status": "active"
}
''',
              'json',
              '''
### Update User
''',
              '''
PUT /users/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John Smith",
  "email": "john.smith@example.com"
}
''',
              'http',
            ),

            // Projects API
            _buildApiSection(
              context,
              'Projects API',
              'Create and manage development projects',
              '''
### List Projects
''',
              '''
GET /projects
Authorization: Bearer <token>
''',
              'http',
              '''
### Create Project
''',
              '''
POST /projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Project",
  "description": "Project description",
  "budget": 5000,
  "deadline": "2024-12-31"
}
''',
              'http',
              '''
**Response:**
''',
              '''
{
  "id": "project_123",
  "name": "New Project",
  "status": "draft",
  "created_at": "2023-01-01T00:00:00Z"
}
''',
              'json',
            ),

            // Files API
            _buildApiSection(
              context,
              'Files API',
              'Upload and manage project files',
              '''
### Upload File
''',
              '''
POST /files/upload
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "file": "[binary data]",
  "project_id": "project_123"
}
''',
              'http',
              '''
### List Project Files
''',
              '''
GET /projects/{id}/files
Authorization: Bearer <token>
''',
              'http',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiSection(BuildContext context, String title, String subtitle,
      [String? text1,
      String? code1,
      String? lang1,
      String? text2,
      String? code2,
      String? lang2,
      String? text3,
      String? code3,
      String? lang3]) {
    // Helper function to build text content
    Widget _buildTextContent(String text) {
      final lines = text.split('\n');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          if (line.startsWith('## ') || line.startsWith('### ')) {
            // Header styling
            final isH2 = line.startsWith('## ');
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                line.replaceAll(RegExp(r'^#+ '), ''),
                style: GoogleFonts.poppins(
                  fontSize: isH2 ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
              ),
            );
          } else if (line.startsWith('- **')) {
            // List item with bold
            final parts = line.split('**');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(text: '• '),
                    TextSpan(
                      text: parts[1],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: parts[2]),
                  ],
                ),
              ),
            );
          } else if (line.startsWith('**') && line.endsWith('**')) {
            // Bold text
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line.replaceAll('**', ''),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            );
          } else if (line.isEmpty) {
            return const SizedBox(height: 8);
          } else if (line.startsWith('1. ') ||
              line.startsWith('2. ') ||
              line.startsWith('3. ')) {
            // Numbered list
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          } else {
            // Regular text
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          }
        }).toList(),
      );
    }

    // Helper function to build code block
    Widget _buildCodeBlock(BuildContext context, String code, String language) {
      final isDesktop = MediaQuery.of(context).size.width > 600;

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D), // Dark IDE-like background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
              child: SelectableText(
                code,
                style: GoogleFonts.firaCode(
                  fontSize: isDesktop ? 14 : 12,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getLanguageColor(language),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      language.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.content_copy,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Build the section content by processing all parameters
    final List<Widget> contentChildren = [];

    void addContent(dynamic content) {
      if (content is String && content.isNotEmpty) {
        contentChildren.add(_buildTextContent(content));
      }
    }

    void addCode(String? code, String? lang) {
      if (code != null && code.isNotEmpty && lang != null) {
        contentChildren.add(_buildCodeBlock(context, code, lang));
      }
    }

    // Process all parameters in order
    addContent(text1);
    addCode(code1, lang1);
    addContent(text2);
    addCode(code2, lang2);
    addContent(text3);
    addCode(code3, lang3);

    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          ...contentChildren,
        ],
      ),
    );
  }

  Color _getLanguageColor(String language) {
    switch (language) {
      case 'http':
        return Colors.blue;
      case 'json':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }
}
