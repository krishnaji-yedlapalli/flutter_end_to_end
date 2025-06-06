import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_latest/core/presentation/provider/route_provider.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

class ShellRouting extends StatelessWidget {
  final Widget widget;

  const ShellRouting(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RouteProvider(),
        child: Scaffold(
          appBar: CustomAppBar(
            title: const Text('Shell Routing'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (GoRouter.of(context).canPop()) GoRouter.of(context).pop();
              },
            ),
            appBar: AppBar(),
          ),
          body: widget,
        ));
  }
}
