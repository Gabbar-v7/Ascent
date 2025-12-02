import 'package:ascent/l10n/generated/app_localizations.dart';
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
        buildSectionHeader(
          AppLocalizations.of(context)!.setting_label_project,
          theme,
        ),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_about_github,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_githubDescription,
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
          title: AppLocalizations.of(context)!.setting_about_report,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_reportDescription,
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
          title: AppLocalizations.of(context)!.setting_about_suggest,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_suggestDescription,
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
          title: AppLocalizations.of(context)!.setting_about_star,
          subtitle: AppLocalizations.of(context)!.setting_about_starDescription,
          leading: Icon(Icons.star_outline_rounded, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: () => launchUrlString(
            "https://github.com/Gabbar-v7/Ascent",
            mode: LaunchMode.externalApplication,
          ),
        ),

        GapEnum.section.gap,
        buildSectionHeader(
          AppLocalizations.of(context)!.setting_label_contact,
          theme,
        ),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_about_emal,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_emailDescription,
          leading: Icon(Icons.mail_outline, size: 28),
          trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          onTap: () =>
              launchUrlString("#", mode: LaunchMode.externalApplication),
        ),

        GapEnum.section.gap,
        buildSectionHeader("Support Development", theme),
        GapEnum.sectionHeader.gap,
        PositionedButton(
          title: AppLocalizations.of(context)!.setting_about_githubSponsor,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_githubSponsorDescription,
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
          title: AppLocalizations.of(context)!.setting_about_buyMeCoffee,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_buyMeCoffeeDescription,
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
          title: AppLocalizations.of(context)!.setting_about_paypal,
          subtitle: AppLocalizations.of(
            context,
          )!.setting_about_paypalDescription,
          leading: Icon(Icons.wallet, size: 28),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined, size: 32),
          position: ItemPosition.bottom,
          onTap: () => launchUrlString(
            "https://www.paypal.com/paypalme/GabbarShall",
            mode: LaunchMode.externalApplication,
          ),
        ),

        GapEnum.section.gap,
      ],
    );
  }
}
