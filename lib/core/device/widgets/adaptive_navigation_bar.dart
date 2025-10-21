import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../config/device_configurations.dart';
import '../../constants/responsive_constants.dart';

/// Adaptive navigation bar
class AdaptiveNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const AdaptiveNavigationBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DeviceConfiguration.useCupertinoDesign) {
      return CupertinoNavigationBar(
        middle: Text(title),
        trailing: actions != null && actions!.isNotEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            : null,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    } else {
      return AppBar(
        title: Text(title),
        actions: actions,
        leading: leading,
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }
  }

  @override
  Size get preferredSize {
    if (DeviceConfiguration.useCupertinoDesign) {
      return const Size.fromHeight(ResponsiveConstants
          .iosNavigationBarHeight); // iOS navigation bar height
    } else {
      return const Size.fromHeight(
          ResponsiveConstants.materialAppBarHeight); // Material app bar height
    }
  }
}
