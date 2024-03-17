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

  double targetValue = 48;
  bool flag = false;
  double scale = .0;
  Offset offset = Offset(0, 0);
  double opacity = .0 ;
  double turns = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rebuildAnimations();
    });
    super.initState();
  }

  void rebuildAnimations() {
    setState(() {
      flag = !flag;
      scale = scale == 0.0 ? 1 : 0.0;
      offset = offset.dx == 0 ? const Offset(0.5, 0.2) : const Offset(0, 0);
      opacity = opacity == 0 ? 1 : 0;
      turns += 1.0 / 8.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildNote('No need to use stateful widget we can also use Stream builder or Future builder as well'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: rebuildAnimations, child: const Text('Toggle Animations')),
        ),
        Expanded(child: _buildAnimationList())
      ],
    ).screenPadding();
  }

  Widget _buildAnimationList() {
    return GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: DeviceConfiguration.isMobileResolution ? 1 : 4,
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
            child: buildTitleWithExpandedContent(title: animationList.elementAt(index).name, content: _buildAnimationView(index), hideBorder: true)));
  }

  Widget _buildAnimationView(int index){
    return switch(index){
    0 => _buildTweenAnimationBuilder,
    1 => _animatedAlignBuilder,
    2 => _animatedContainerBuilder,
    3 => _animatedDefaultTextStyle,
    4 => _animatedScale,
    5 => _buildAnimatedRotation,
    6 => _buildAnimatedSlide,
    7 => _buildAnimatedOpacity,
    _ => SizedBox()
  };
  }

  Widget get _buildTweenAnimationBuilder {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double size, Widget? child) {
        return FlutterLogo(size: 80);
      },
      child: const Icon(Icons.aspect_ratio),
    );
  }
  
  
  Widget get _animatedAlignBuilder {
    return AnimatedAlign(
        alignment: flag ? Alignment.topRight : Alignment.bottomLeft, duration: Duration(seconds: 1),
        child: const FlutterLogo(size: 80),
    );
  }

  Widget get _animatedContainerBuilder {
    return AnimatedContainer(
      width: flag ? 100 : 0,
      height: flag ? 50 : 0,
      duration: const Duration(seconds: 1),
      color: Colors.black26,
      child: FlutterLogo(),
    );
  }

  Widget get _animatedDefaultTextStyle {
    return Align(
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(textAlign: TextAlign.center, style: flag ? TextStyle(fontWeight: FontWeight.bold, color: Colors.purpleAccent,) : TextStyle(fontWeight: FontWeight.w300, color: Colors.cyan), duration: Duration(seconds: 1), child: const Text('Heloo World, Lets practice implicit animations')));
  }

  Widget get _animatedScale {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(seconds: 1),
      child: const FlutterLogo(size: 100)
    );
  }

  Widget get _buildAnimatedRotation {
    return AnimatedRotation(turns: turns, duration: const Duration(seconds: 1), child: const FlutterLogo(size: 100));
  }
  
  Widget get _buildAnimatedSlide {
    return AnimatedSlide(offset: offset, duration: const Duration(seconds: 1), child: const FlutterLogo(size: 80));
  }

  Widget get _buildAnimatedOpacity {
    return AnimatedOpacity(opacity: opacity, duration: const Duration(seconds: 1), child: const FlutterLogo(size: 80));
  }

}
