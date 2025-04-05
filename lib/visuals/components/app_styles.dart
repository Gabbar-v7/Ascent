import 'package:flutter/material.dart';
import 'package:ascent/visuals/utils/nav_manager.dart';
import 'package:gap/gap.dart';

class AppStyles {
  static AppBar appBar(
    String title,
    BuildContext context, {
    IconData icon = Icons.arrow_back_ios_rounded,
    List<Widget> actions = const [],
    Color? backgroundColor,
  }) {
    return AppBar(
      leading: IconButton(
        icon: Icon(icon, size: 27),
        onPressed: () => NavManager.popPage(context),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      actions: actions,
      backgroundColor: backgroundColor,
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

  static Widget listTile({
    required String title,
    String? body,
    required Widget leading,
    required Widget trailing,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    bool showDivider = true,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row (leading + title + trailing)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leading,
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: trailing,
                  ),
                ],
              ),

              // Conditional divider and body
              if (body != null && body.isNotEmpty) ...[
                if (showDivider)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                const Gap(8),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    body,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
