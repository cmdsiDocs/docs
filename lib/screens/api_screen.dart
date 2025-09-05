// screens/api_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            'Authentication',
            'Secure your API requests with JWT tokens',
            '''
## Base URLs
- **Production**: https://api.cleverminds.com/v1
- **Sandbox**: https://api-sandbox.cleverminds.com/v1

## Authentication
All API requests require authentication. Include your API key in the header:

\`\`\`http
Authorization: Bearer YOUR_API_KEY
\`\`\`

## Getting API Key
1. Sign up for an account
2. Go to Dashboard → API Settings
3. Generate your API key
''',
          ),

          // Users API
          _buildApiSection(
            'Users API',
            'Manage user accounts and profiles',
            '''
### Get User Profile
\`\`\`http
GET /users/{id}
Authorization: Bearer <token>
\`\`\`

**Response:**
\`\`\`json
{
  "id": "user_123",
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2023-01-01T00:00:00Z",
  "status": "active"
}
\`\`\`

### Update User
\`\`\`http
PUT /users/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "John Smith",
  "email": "john.smith@example.com"
}
\`\`\`
''',
          ),

          // Projects API
          _buildApiSection(
            'Projects API',
            'Create and manage development projects',
            '''
### List Projects
\`\`\`http
GET /projects
Authorization: Bearer <token>
\`\`\`

### Create Project
\`\`\`http
POST /projects
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "New Project",
  "description": "Project description",
  "budget": 5000,
  "deadline": "2024-12-31"
}
\`\`\`

**Response:**
\`\`\`json
{
  "id": "project_123",
  "name": "New Project",
  "status": "draft",
  "created_at": "2023-01-01T00:00:00Z"
}
\`\`\`
''',
          ),

          // Files API
          _buildApiSection(
            'Files API',
            'Upload and manage project files',
            '''
### Upload File
\`\`\`http
POST /files/upload
Authorization: Bearer <token>
Content-Type: multipart/form-data

{
  "file": "[binary data]",
  "project_id": "project_123"
}
\`\`\`

### List Project Files
\`\`\`http
GET /projects/{id}/files
Authorization: Bearer <token>
\`\`\`
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
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
