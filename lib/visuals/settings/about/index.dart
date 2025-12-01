import 'package:ascent/visuals/components/utils/gap_utils.dart';
import 'package:ascent/visuals/components/utils/item_position.dart';
import 'package:ascent/visuals/components/widgets/positioned_button.dart';
import 'package:ascent/visuals/settings/components.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutIndex extends StatefulWidget {
  const AboutIndex({super.key});

  @override
  State<StatefulWidget> createState() => _AboutIndexState();
}

class _AboutIndexState extends State<AboutIndex> {
  late final ThemeData theme = Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GapEnum.section.gap,
        buildSectionHeader("Project", theme),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: "GitHub",
          subtitle: "View the source code",
          leading: Icon(Icons.code, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.top,
          onTap: () => launchUrlString(
            "https://github.com/Gabbar-v7/Ascent",
            mode: LaunchMode.externalApplication,
          ),
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: "Report an issue",
          subtitle: "Help us improve the app",
          leading: Icon(Icons.bug_report_outlined, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.mid,
          onTap: () => launchUrlString(
            "https://github.com/Gabbar-v7/Ascent/issues/new",
            mode: LaunchMode.externalApplication,
          ),
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: "Suggest an idea",
          subtitle: "Share your feature requests",
          leading: Icon(Icons.lightbulb_outline_rounded, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.mid,
          onTap: () => launchUrlString(
            "https://github.com/Gabbar-v7/Ascent/issues/new",
            mode: LaunchMode.externalApplication,
          ),
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: "Star on GitHub",
          subtitle: "Support the project",
          leading: Icon(Icons.star_outline_rounded, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: () => launchUrlString(
            "https://github.com/Gabbar-v7/Ascent",
            mode: LaunchMode.externalApplication,
          ),
        ),

        GapEnum.section.gap,
        buildSectionHeader("Contact", theme),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: "Email us",
          subtitle: "#",
          leading: Icon(Icons.mail_outline, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          onTap: () =>
              launchUrlString("#", mode: LaunchMode.externalApplication),
        ),

        GapEnum.section.gap,
        buildSectionHeader("Support Development", theme),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: "GitHub sponsor",
          subtitle: "Monthly support",
          leading: Icon(Icons.favorite_border_rounded, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.top,
          onTap: () => launchUrlString(
            "https://github.com/sponsors/Gabbar-v7",
            mode: LaunchMode.externalApplication,
          ),
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: "Buy me a coffee",
          subtitle: "One-time donation",
          leading: const Icon(Icons.coffee_outlined, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.mid,
          onTap: () => launchUrlString(
            'https://buymeacoffee.com/gabbar_v7',
            mode: LaunchMode.externalApplication,
          ),
        ),
        GapEnum.sectionContent.gap,
        PositionedButton(
          title: "PayPal",
          subtitle: "One-time donation",
          leading: Icon(Icons.wallet, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: () => launchUrlString(
            "https://www.paypal.com/paypalme/GabbarShall",
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
    );
  }
}
