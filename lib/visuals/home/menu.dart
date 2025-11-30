import 'package:ascent/visuals/components/utils/navigator_utils.dart';
import 'package:ascent/visuals/components/widgets/in_progress.dart';
import 'package:ascent/visuals/settings/index.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void showAuxiliaryMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => _AuxiliaryMenuSheet(),
  );
}

class _AuxiliaryMenuSheet extends StatelessWidget {
  late final BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return SafeArea(
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(1),
            _appBar(),
            const Gap(40),
            InProgressPage(),
            const Gap(40),
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text("Menu", style: Theme.of(context).textTheme.titleMedium),
      leading: IconButton(
        onPressed: () => {NavigatorUtils.popPage(context)},
        icon: Icon(Icons.arrow_back_ios_rounded),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.timeline, size: 28)),
        IconButton(
          onPressed: () {
            NavigatorUtils.popPage(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsIndex()),
            );
          },
          icon: Icon(Icons.settings_outlined, size: 27),
        ),
        const Gap(5),
      ],
    );
  }
}
