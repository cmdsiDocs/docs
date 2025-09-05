// screens/api_documentation_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApiDocumentationScreen extends StatelessWidget {
  const ApiDocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Documentation',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Comprehensive guide to our RESTful APIs',
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),

          // Authentication Section
          _buildApiSection(
            'Authentication',
            'All API requests require authentication using JWT tokens.',
            '''
## Getting Started

1. Obtain your API key from the dashboard
2. Include the API key in the header:
   \`Authorization: Bearer YOUR_API_KEY\`

## Endpoints

- **Base URL**: https://api.cleverminds.com/v1
- **Sandbox URL**: https://api-sandbox.cleverminds.com/v1
''',
          ),

          // Users API
          _buildApiSection(
            'Users API',
            'Manage user accounts and profiles.',
            '''
### Get User Profile
\`\`\`http
GET /users/{id}
Authorization: Bearer <token>
\`\`\`

**Response:**
\`\`\`json
{
  "id": "123",
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2023-01-01T00:00:00Z"
}
\`\`\`
''',
          ),

          // Projects API
          _buildApiSection('Projects API', 'Create and manage projects.', '''
### Create Project
\`\`\`http
POST /projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Project",
  "description": "Project description"
}
\`\`\`

**Response:**
\`\`\`json
{
  "id": "project_123",
  "name": "New Project",
  "status": "active"
}
\`\`\`
'''),

          // Error Codes
          _buildApiSection(
            'Error Codes',
            'Common error responses and their meanings.',
            '''
| Code | Message | Description |
|------|---------|-------------|
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Invalid or missing authentication |
| 404 | Not Found | Resource not found |
| 500 | Internal Error | Server error |
''',
          ),
        ],
      ),
    );
  }

  Widget _buildApiSection(String title, String subtitle, String content) {
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
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Text(content, style: GoogleFonts.poppins(fontSize: 14)),
        ],
      ),
    );
  }
}
