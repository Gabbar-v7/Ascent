import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigatorUtils {
  static void popPage(BuildContext context) => (Navigator.canPop(context))
      ? Navigator.pop(context)
      : SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}
