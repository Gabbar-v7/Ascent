import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bold text in the center
          Text('In Progress', style: Theme.of(context).textTheme.displaySmall),
          const Gap(20), // Spacing
          // Informative text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'This page is currently under development.\nPlease check GitHub for updates.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const Gap(20), // Spacing
          // Button to open GitHub URL
          ElevatedButton(
            onPressed: _launchGithubUrl,
            child: Text(
              'Visit GitHub',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
