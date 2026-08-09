import 'package:app_core/core/constants/responsive_constants.dart';
import 'package:app_core/core/device/config/device_configurations.dart';
import 'package:app_core/core/environment/environment.dart';
import 'package:app_core/core/routing/navigation_utils.dart';
import 'package:app_core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/provider/common_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? leading;

  const CustomAppBar(
      {required this.appBar,
      Key? key,
      this.title,
      this.actions,
      this.bottom,
      this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: DeviceConfiguration.isWeb
          ? InkResponse(
              child: Padding(
                padding: const EdgeInsets.all(ResponsiveConstants.tinyPadding),
                child: Image.asset(Environment().configuration.appBarLogoPath),
              ),
              onTap: () => NavigationUtils.navigateToHome(context))
          : leading,
      title: title,
      centerTitle: true,
      bottom: bottom,
      actions: [
        ...actions ?? [],
        TextButton.icon(
            onPressed: context.read<CommonProvider>().onChangeOfTheme,
            icon: Icon(context.watch<CommonProvider>().isLightTheme
                ? Icons.dark_mode
                : Icons.light_mode),
            label: DeviceConfiguration.isMobileResolution
                ? const Text('')
                : Text(
                    context.watch<CommonProvider>().isLightTheme
                        ? AppLocalizations.of(context)!.darkTheme
                        : AppLocalizations.of(context)!.lightTheme,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.apply(color: Colors.white)))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height +
      (bottom != null ? appBar.preferredSize.height : 0));
}
