import 'package:ascent/visuals/components/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InProgressPage extends StatelessWidget {
  InProgressPage({super.key});

  // GitHub URL to open
  final Uri githubUrl = Uri.parse('https://github.com/Gabbar-v7/Ascent');

  // Function to launch the GitHub URL
  Future<void> _launchGithubUrl() async {
    if (await canLaunchUrl(githubUrl)) {
      await launchUrl(githubUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $githubUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar("In Progress", context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bold text in the center
            Text(
              'In Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Spacing
            // Informative text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'This page is currently under development.\nPlease check GitHub for updates.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20), // Spacing
            // Button to open GitHub URL
            ElevatedButton(
              onPressed: _launchGithubUrl,
              child: Text('Visit GitHub'),
            ),
          ],
        ),
      ),
    );
  }
}
