import 'package:flutter/material.dart';
import 'package:ascent/visuals/utils/nav_manager.dart';

class AppStyles {
  static AppBar appBar(
    String title,
    BuildContext context, {
    IconData icon = Icons.arrow_back_ios_rounded,
    List<Widget> actions = const <Widget>[],
    Color? backgroundColor,
  }) {
    return AppBar(
      leading: IconButton(
        icon: Icon(icon),
        onPressed: () => NavManager.popPage(context),
      ),
      title: Text(title, style: Theme.of(context).textTheme.headlineLarge),
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }
}
