import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/device/config/device_configurations.dart';
import 'package:sample_latest/core/widgets/custom_app_bar.dart';

class PageNotFound extends StatelessWidget {
  final GoRouterState state;

  const PageNotFound(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          appBar: AppBar(),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          double? size = DeviceConfiguration.isMobileResolution ? null : null;
          return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Wrap(spacing: 10, runSpacing: 10, children: [
                Text('${state.error?.message}\n'),
                Image.asset('asset/exception_error/page_not_found.png',
                    fit: BoxFit.scaleDown, height: size, width: size),
              ]));
        }));
  }
}
