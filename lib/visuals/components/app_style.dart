import 'package:flutter/material.dart';
import 'package:ascent/visuals/utils/nav_manager.dart';

class AppStyle {
  BuildContext context;

  AppStyle({required this.context});

  AppBar appBar(
    String title, {
    IconData icon = Icons.arrow_back_ios_rounded,
    List<Widget> actions = const [],
  }) {
    return AppBar(
      leading: IconButton(
        icon: Icon(icon, size: 27),
        onPressed: () => NavManager.popPage(context),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      actions: actions,
    );
  }

  FloatingActionButton floatingActionButton(
    IconData icon,
    VoidCallback onPress,
  ) {
    return FloatingActionButton(
      onPressed: onPress,
      child: Icon(icon, size: 27),
    );
  }
}
