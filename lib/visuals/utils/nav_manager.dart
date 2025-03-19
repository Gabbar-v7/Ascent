import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavManager {
  static popPage(BuildContext context) =>
      (Navigator.canPop(context))
          ? Navigator.pop(context)
          : SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}
