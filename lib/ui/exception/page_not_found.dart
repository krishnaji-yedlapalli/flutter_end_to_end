
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class PageNotFound extends StatelessWidget {

  final GoRouterState state;

  PageNotFound(this.state, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double? size = DeviceConfiguration.isMobileResolution ? null :  null;
          return Container(
            padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Image.asset('asset/exception_error/page_not_found.png', fit: BoxFit.scaleDown, height: size, width: size));
        }
      )
    );
  }
}
