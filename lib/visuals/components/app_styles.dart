import 'package:flutter/material.dart';
import 'package:ascent/visuals/utils/nav_manager.dart';

class AppStyles {
  static AppBar appBar(
    String title,
    BuildContext context, {
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

  static FloatingActionButton floatingActionButton(
    IconData icon,
    VoidCallback onPress,
  ) {
    return FloatingActionButton(
      onPressed: onPress,
      child: Icon(icon, size: 27),
    );
  }
}
