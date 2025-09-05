// screens/documentation_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documentation',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Comprehensive guides and tutorials',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),

          // Getting Started
          _buildDocSection(
            'Getting Started',
            'Quick start guide for new users',
            '''
## Installation
\`\`\`bash
# Install the CLI tool
npm install -g @cleverminds/cli

# Or using yarn
yarn global add @cleverminds/cli
\`\`\`

## Configuration
\`\`\`bash
# Initialize your project
cmdsi init

# Configure your API key
cmdsi config set api-key YOUR_API_KEY
\`\`\`

## First Project
1. Create a new project directory
2. Run \`cmdsi init\`
3. Follow the setup wizard
4. Start developing!
''',
          ),

          // SDK Documentation
          _buildDocSection(
            'SDK Documentation',
            'Client libraries for various languages',
            '''
## JavaScript/Node.js
\`\`\`javascript
const { CleverMindsAPI } = require('@cleverminds/sdk');

const client = new CleverMindsAPI({
  apiKey: process.env.CLEVERMINDS_API_KEY
});

// Example usage
const projects = await client.projects.list();
\`\`\`

## Python
\`\`\`python
from cleverminds import CleverMindsClient

client = CleverMindsClient(api_key="your-api-key")

# List projects
projects = client.projects.list()
\`\`\`

## PHP
\`\`\`php
require_once 'vendor/autoload.php';

 
\`\`\`
''',
          ),

          // Tutorials
          _buildDocSection(
            'Tutorials',
            'Step-by-step guides for common tasks',
            '''
## Creating Your First API Request
1. Obtain your API key from the dashboard
2. Set up authentication headers
3. Make a test request to verify connectivity

## Error Handling
\`\`\`javascript
try {
  const response = await client.projects.create(projectData);
} catch (error) {
  if (error.status === 401) {
    console.error('Authentication failed');
  } else if (error.status === 429) {
    console.error('Rate limit exceeded');
  }
}
\`\`\`

## Best Practices
- Always validate input data
- Implement proper error handling
- Use pagination for large datasets
- Cache responses when appropriate
''',
          ),

          // FAQ Section
          _buildDocSection(
            'Frequently Asked Questions',
            'Common questions and solutions',
            '''
### Q: How do I reset my API key?
A: Go to Dashboard → API Settings → Regenerate Key

### Q: What are the rate limits?
A: Free tier: 100 requests/hour, Paid tiers: 1000-10,000 requests/hour

### Q: How do I handle errors?
A: Check the error response format and implement proper error handling

### Q: Is there a sandbox environment?
A: Yes, use https://api-sandbox.cleverminds.com for testing

### Q: How do I upgrade my plan?
A: Contact sales@cleverminds.com or upgrade in the dashboard
''',
          ),

          // Support Section
          _buildDocSection(
            'Support & Resources',
            'Get help and find additional resources',
            '''
## Community Support
- **GitHub Discussions**: https://github.com/cleverminds/sdk/discussions
- **Stack Overflow**: Tag questions with #cleverminds
- **Discord Community**: Join our developer community

## Additional Resources
- **API Changelog**: https://docs.cleverminds.com/changelog
- **Status Page**: https://status.cleverminds.com
- **Blog**: https://blog.cleverminds.com

## Contact Support
- **Email**: support@cleverminds.com
- **Response Time**: Typically within 24 hours
- **Emergency**: For critical issues, call +1-555-SUPPORT
''',
          ),
        ],
      ),
    );
  }

  Widget _buildDocSection(String title, String subtitle, String content) {
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
