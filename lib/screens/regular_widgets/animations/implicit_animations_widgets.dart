import 'package:flutter/material.dart';
import 'package:sample_latest/extensions/widget_extension.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class ImplicitAnimationsWidgets extends StatefulWidget {
  const ImplicitAnimationsWidgets({Key? key}) : super(key: key);

  @override
  State<ImplicitAnimationsWidgets> createState() => _ImplicitAnimationsState();
}

class _ImplicitAnimationsState extends State<ImplicitAnimationsWidgets> with HelperWidget {

  List<({String name, String link})> animationList = [
  (name: 'TweenAnimationBuilder', link : 'https://api.flutter.dev/flutter/widgets/TweenAnimationBuilder-class.html'),
  (name: 'AnimatedAlign', link : 'https://api.flutter.dev/flutter/widgets/AnimatedAlign-class.html'),
  (name: 'AnimatedContainer', link : 'https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html'),
  (name: 'AnimatedDefaultTextStyle', link : 'https://api.flutter.dev/flutter/widgets/AnimatedDefaultTextStyle-class.html'),
  (name: 'AnimatedScale', link : 'https://api.flutter.dev/flutter/widgets/AnimatedScale-class.html'),
  (name: 'AnimatedRotation', link : 'https://api.flutter.dev/flutter/widgets/AnimatedRotation-class.html'),
  (name: 'AnimatedSlide', link : 'https://api.flutter.dev/flutter/widgets/AnimatedSlide-class.html'),
  (name: 'AnimatedOpacity', link : 'https://api.flutter.dev/flutter/widgets/AnimatedOpacity-class.html'),
  (name: 'AnimatedPadding', link : 'https://api.flutter.dev/flutter/widgets/AnimatedPadding-class.html'),
  (name: 'AnimatedPhysicalModel', link : 'https://api.flutter.dev/flutter/widgets/AnimatedPhysicalModel-class.html'),
  (name: 'AnimatedPositioned', link : 'https://api.flutter.dev/flutter/widgets/AnimatedPositioned-class.html'),
  (name: 'AnimatedPositionedDirectional', link : 'https://api.flutter.dev/flutter/widgets/AnimatedPositionedDirectional-class.html'),
  (name: 'AnimatedTheme', link : 'https://api.flutter.dev/flutter/material/AnimatedTheme-class.html'),
  (name: 'AnimatedCrossFade', link : 'https://api.flutter.dev/flutter/widgets/AnimatedCrossFade-class.html'),
  (name: 'AnimatedSize', link : 'https://api.flutter.dev/flutter/widgets/AnimatedSize-class.html'),
  (name: 'AnimatedSwitcher', link : 'https://api.flutter.dev/flutter/widgets/AnimatedSwitcher-class.html'),
  ];

  double targetValue = 24.0;

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
    0 => _buildTweenAnimationBuilder,
    _ => SizedBox()
  };
  }

  Widget get _buildTweenAnimationBuilder {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double size, Widget? child) {
        return IconButton(
          iconSize: size,
          color: Colors.blue,
          icon: child!,
          onPressed: () {
            setState(() {
              targetValue = targetValue == 24.0 ? 48.0 : 24.0;
            });
          },
        );
      },
      child: const Icon(Icons.aspect_ratio),
    );
  }
}
