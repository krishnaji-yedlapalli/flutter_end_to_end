
import 'package:flutter/material.dart';
import 'package:sample_latest/mixins/cards_mixin.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class ScrollTypes extends StatelessWidget with CardWidgetsMixin {
  const ScrollTypes({Key? key}) : super(key: key);

  final List<({String name, String link})> animationList = const [
  (name: 'Scroll Bar', link : ''),
  (name: 'List View', link : ''),
  (name: 'Animated List', link : ''),
  (name: 'Grid View', link : ''),
  (name: 'List Wheel Scroll View', link : 'https://api.flutter.dev/flutter/widgets/ListWheelScrollView-class.html'),
  (name: 'Draggable Scrollable sheet', link : ''),
  (name: 'Silver App Bar', link : ''),
  (name: 'Silver List', link : ''),
  (name: 'Silver Grid', link : ''),
  (name: 'Custom Scroll view', link : 'https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html'),
  (name: 'Two Dimensional Scrolling', link : 'https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html'),
  (name: 'Scrolling Parallax effect', link : 'https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
    title: const Text('Scroll Types'),
    appBar: AppBar()),
      body: GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  DeviceConfiguration.isMobileResolution ? 2 : 6),
     itemCount: animationList.length,
     itemBuilder: (context, index) {
      var item = animationList.elementAt(index);
      return buildHomeCardView(title: item.name,
       des: '',
       callback: nav, icon: Icons.roller_shades
      );
  }),
    );
  }
  
  void nav() {
    
  }
}
