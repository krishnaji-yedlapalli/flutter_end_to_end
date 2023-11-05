
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/provider/common_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final AppBar appBar;
  final Widget? title;

   const CustomAppBar({required this.appBar, Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        TextButton.icon(onPressed: context.read<CommonProvider>().onChangeOfTheme, icon:  Icon(context.watch<CommonProvider>().isLightTheme ? Icons.dark_mode : Icons.light_mode), label: Text(context.watch<CommonProvider>().isLightTheme ? 'Dark Theme' : 'Light Theme', style: Theme.of(context).textTheme.titleMedium?.apply(color: Colors.white)))
      ],
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
