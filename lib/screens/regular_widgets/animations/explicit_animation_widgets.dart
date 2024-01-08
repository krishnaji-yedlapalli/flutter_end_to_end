import 'package:flutter/material.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class ExplicitAnimationsWidgets extends StatefulWidget {
  const ExplicitAnimationsWidgets({Key? key}) : super(key: key);

  @override
  State<ExplicitAnimationsWidgets> createState() => _ExplicitAnimationsWidgetsState();
}

class _ExplicitAnimationsWidgetsState extends State<ExplicitAnimationsWidgets> with HelperWidget{

  List<({String name, String link})> animationList = [
  (name: 'ListenableBuilder', link : 'https://api.flutter.dev/flutter/widgets/ListenableBuilder-class.html'),
  (name: 'AnimatedBuilder', link : 'https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html'),
  (name: 'AlignTransition', link : 'https://api.flutter.dev/flutter/widgets/AlignTransition-class.html'),
  (name: 'DecoratedBoxTransition', link : 'https://api.flutter.dev/flutter/widgets/DecoratedBoxTransition-class.html'),
  (name: 'DefaultTextStyleTransition', link : 'https://api.flutter.dev/flutter/widgets/DefaultTextStyleTransition-class.html'),
  (name: 'PositionedTransition', link : 'https://api.flutter.dev/flutter/widgets/PositionedTransition-class.html'),
  (name: 'RelativePositionedTransition', link : 'https://api.flutter.dev/flutter/widgets/RelativePositionedTransition-class.html'),
  (name: 'RotationTransition', link : 'https://api.flutter.dev/flutter/widgets/RotationTransition-class.html'),
  (name: 'ScaleTransition', link : 'https://api.flutter.dev/flutter/widgets/ScaleTransition-class.html'),
  (name: 'SizeTransition', link : 'https://api.flutter.dev/flutter/widgets/SizeTransition-class.html'),
  (name: 'SlideTransition', link : 'https://api.flutter.dev/flutter/widgets/SlideTransition-class.html'),
  (name: 'FadeTransition', link : 'https://api.flutter.dev/flutter/widgets/FadeTransition-class.html'),
  (name: 'AnimatedModalBarrier', link : 'https://api.flutter.dev/flutter/widgets/AnimatedModalBarrier-class.html'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildNote('No need to use stateful widget we can also use Stream builder or Future builder as well'),
        Expanded(child: _buildAnimationList())
      ],
    ).screenPadding();
  }

  Widget _buildAnimationList() {
    return GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: DeviceConfiguration.isMobileResolution ? 1 : 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20
    ),
        itemCount: animationList.length,
        itemBuilder: (context, index) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: buildTitleWithContent(title: animationList.elementAt(index).name, content: _buildAnimationView(index), hideBorder: true)));
  }

  Widget _buildAnimationView(int index){
    return switch(index){
    0 => SizedBox(),
    1 => SizedBox(),
    _ => SizedBox()
  };
  }

}
