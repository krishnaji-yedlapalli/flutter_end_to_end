import 'package:flutter/material.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/utils/device_configurations.dart';

class MaterialComponents extends StatefulWidget {
  const MaterialComponents({Key? key}) : super(key: key);

  @override
  State<MaterialComponents> createState() => _MaterialComponentsState();
}

class _MaterialComponentsState extends State<MaterialComponents> with HelperWidget {
  bool value = false;
  bool checkBoxMenuItem = false;
  int radioGroupValue = 0;
  Set<int> selectedSegmentIndex = {0};
  Set<int> selectedMultiSegmentIndex = {1};
  double sliderValue = .2;
  bool switchFlag = false;
  var segments = [const ButtonSegment<int>(value: 0, label: Text('Hi'), icon: Icon(Icons.wifi_tethering_error), tooltip: 'Hi there !!'), const ButtonSegment<int>(value: 1, label: Text('Hello'), tooltip: 'Hello there !!'),
    const ButtonSegment<int>(value: 2, label: Text('there'), tooltip: 'Hi Hello there !!')
  ];

  @override
  Widget build(BuildContext context) {
    var materialWidgets = [
      _buildBadges(), _buildCheckBox(), _progressIndicators(), _buildChips(), _buildRadioButtons(), _buildSegmentedButtons(), _buildMultiSegmentedButtons(),  _buildFABButtons(), _buildSliders(), _buildSwitches(), _buildToolTips(), _buildMenuItems(), _buildPopupMenuItems()
    ];
    var count = 0;
    return Container(
      padding: EdgeInsets.all(20),
      child: !DeviceConfiguration.isMobileResolution ? SingleChildScrollView(
        child: Wrap(
          spacing: 50,
          runSpacing: 50,
          direction: Axis.horizontal,
          children: List.generate(materialWidgets.length * 2  - 1, (index){
            if(index%2 == 0){
              return materialWidgets.elementAt(count++);
            }else{
             return vDivider;
            }
          })),
      ) :
        ListView.separated(itemBuilder: (context ,index) => materialWidgets.elementAt(index), separatorBuilder: (context ,index) => hDivider, itemCount: materialWidgets.length, shrinkWrap: true,)
      );
  }

  Widget _buildBadges() {
    return buildTitleWithContent(
      title: 'Badges',
      content: Wrap(
        runSpacing: 20,
        spacing: 20,
        children: [
          Badge(label: Text('20'), child: IconButton(onPressed: () {}, icon: Icon(Icons.message))),
          Badge(label: Text('10+'), offset: Offset(10, 5), child: IconButton(onPressed: () {}, icon: Icon(Icons.notification_add))),
          Badge(label: Text('200+'), offset: Offset(10, 10), child: IconButton(onPressed: () {}, icon: Icon(Icons.notification_add))),
        ],
      ),
    );
  }

  Widget _buildCheckBox() {
    return buildTitleWithContent(
        title: 'Check Boxes',
        content: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Checkbox(value: value, onChanged: onChange),
            SizedBox(width: 300, child: CheckboxListTile(title: Text('CheckBox List Tile'), value: value, onChanged: onChange)),
            SizedBox(
             width: 300,
              child: CheckboxMenuButton(
                child: Text('Heloo'),
                onChanged: onChangeCheckBoxMenuItem,
                value: checkBoxMenuItem,
              ),
            ),
          ],
        ));
  }

  Widget _buildChips() {
    return buildTitleWithContent(
        title: 'Check Boxes',
        content: Wrap(
          spacing: 15,
          children: [
            Chip(label: Text('Chip')),
            Chip(label: Text('Chip'), deleteIcon: Icon(Icons.close), onDeleted: (){}),
            Chip(label: Text('Chip'), deleteIcon: Icon(Icons.close), onDeleted: (){}, avatar: Icon(Icons.person)),
            Chip(label: Text('Chip'), deleteIcon: Icon(Icons.close), onDeleted: (){}, avatar: Icon(Icons.person), side: BorderSide(width: 2)),
            Chip(label: Text('Chip'), deleteIcon: Icon(Icons.close), onDeleted: (){}, avatar: Icon(Icons.person), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)))),
          ],
        ));
  }

  Widget _progressIndicators() {
    return  buildTitleWithContent(
        title: 'Progress Indicators',
        content: Wrap(
          spacing: 20,
          runSpacing: 20,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width : 200, child: LinearProgressIndicator()),
            CircularProgressIndicator()
          ],
        ));
  }

  Widget _buildRadioButtons() {
    return buildTitleWithContent(
        title: 'Radio Buttons',
        content: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Wrap(
              direction: Axis.vertical,
              children: [
                Radio(value: 0, groupValue: radioGroupValue, onChanged: onChangeRadioButton),
                Radio(value: 1, groupValue: radioGroupValue, onChanged: onChangeRadioButton),
              ],
            ),
            SizedBox(
              height: 50,
              child: VerticalDivider(),
            ),
            SizedBox(width: 300, child: RadioListTile(title: Text('CheckBox List Tile'), value: 2, groupValue: radioGroupValue, onChanged: onChangeRadioButton)),
            // Radio.adaptive(value: value, groupValue: groupValue, onChanged: onChanged)
          ],
        ));
  }

  Widget _buildSegmentedButtons() {
    return buildTitleWithContent(
        title: 'Single Segmented Buttons',
        content: SegmentedButton(segments: segments, selected: selectedSegmentIndex, selectedIcon: const Icon(Icons.gesture), showSelectedIcon: true, onSelectionChanged:  (Set<int> items){
          setState(() {
            selectedSegmentIndex = items;
          });
        })
    );
  }

  Widget _buildMultiSegmentedButtons() {
    return buildTitleWithContent(
        title: 'Multi Segmented Buttons',
        content: SegmentedButton<int>(segments: segments, selected: selectedMultiSegmentIndex, multiSelectionEnabled: true, onSelectionChanged:  (Set<int> items){
          setState(() {
            selectedMultiSegmentIndex = items;
          });

        },
        emptySelectionAllowed: true,
          style: ButtonStyle(
            elevation: MaterialStateProperty.resolveWith((states) {
              if(states.contains(MaterialState.hovered)){
                return 5;
              }
              return 0;
            })
          ),
        )
    );
  }

  Widget _buildFABButtons() {
    return buildTitleWithContent(title: 'Floating Action Buttons', content: Wrap(
      spacing: 20,
      children: [
       FloatingActionButton(onPressed: (){}, child: Icon(Icons.edit)),
       FloatingActionButton.extended(onPressed: (){}, label: Text('Extended !!!')),
        FloatingActionButton.large(onPressed: (){}, child: Text('Large')),
        FloatingActionButton.small(onPressed: (){}, child: Text('Small'))
      ],
    ));
  }

  Widget _buildSliders() {
    return buildTitleWithContent(title: 'Sliders', content: Wrap(
      direction: Axis.vertical,
    children : [
      SizedBox(
        width: 250,
        child: Slider.adaptive(value: sliderValue,
            label: 'Adaptive slider',
            onChanged: (val){
          setState(() {
            sliderValue = val;
          });
        }),
      ),
      SizedBox(
        width: 250,
        child: Slider(value: sliderValue,
            label: sliderValue.round().toString(),
            secondaryTrackValue: 0.5,
            // allowedInteraction: SliderInteraction.slideThumb,
            // allowedInteraction: SliderInteraction.slideOnly,
            allowedInteraction: SliderInteraction.tapAndSlide,
            // allowedInteraction: SliderInteraction.tapOnly,
            divisions: 5,
            max: 1,
            min: 0,
            onChanged: (val){
              setState(() {
                sliderValue = val;
              });
            }),
      )
    ]
    ),
    );
    }

  Widget _buildSwitches() {
    return buildTitleWithContent(title: 'Switches', content: Wrap(
        direction: Axis.vertical,
        children : [
          Switch(value: switchFlag, onChanged: onChangeOfSwitch),
          Switch.adaptive(value: switchFlag, onChanged: onChangeOfSwitch),
        ]));
  }

  Widget _buildToolTips() {
    return buildTitleWithContent(title: 'Tool Tips', content: Wrap(
        direction: Axis.vertical,
        spacing: 10,
        children : [
          Tooltip(
              message: 'Tool tip 1',
              child: Text('Tool tip 1', style: Theme.of(context).textTheme.titleSmall)),
          Tooltip( message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam turpis mauris, scelerisque ac diam ac, tincidunt finibus felis. Phasellus blandit efficitur ligula a varius. Nam faucibus aliquam velit a bibendum. Nunc imperdiet augue quis imperdiet hendrerit. Vestibulum feugiat ipsum id elementum hendrerit. Integer eu leo at justo egestas convallis. Cras vitae euismod massa. Nunc pellentesque dictum auctor. Maecenas eget cursus velit, eget efficitur ipsum.', child: Text('Tool tip 2', style: Theme.of(context).textTheme.titleSmall)),
        ]));
  }


  Widget _buildPopupMenuItems() {
    return buildTitleWithContent(title: 'Popup Menu Items', content:
    PopupMenuButton(
        tooltip: 'Pop Menu items',
        onOpened: () {
          debugPrint('on Opened');
        },
        onCanceled:  () {
          debugPrint('on cancelled');
        },
        onSelected: (val) {
          debugPrint('value : $val');
        },
        enableFeedback: true,
        // icon: Icon(Icons.dialpad_outlined),
        itemBuilder: (context) {
      return <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(child: Text('Pop up 1'),
        value: 0,
        ),
        const PopupMenuDivider(height: 0.5),
        const PopupMenuItem(child: Text('Pop up 2'), value: 1,),
        const PopupMenuDivider(height: 0.5),
        const PopupMenuItem(child: Text('Disabled Item'), value: 2, enabled: false,),
      ];
    },
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(2))
            ),
            child: const Text('Pop up Items')))
    );
  }




  Widget _buildMenuItems() {
    return buildTitleWithContent(title: 'Simple Menu Items', content: Wrap(
        direction: Axis.vertical,
        spacing: 10,
        children : [
           MenuAnchor(menuChildren: [
             MenuItemButton(
               child: Text('Sample 1'),
               onPressed: () {},
             ),
             MenuItemButton(
               child: Text('Sample 2'),
               onPressed: () {},
             ),
           ])
         ]));
  }


  void onChangeOfSwitch(val) {
    setState(() {
      switchFlag = val;
    });
  }

  void onChange(val) {
    setState(() {
      value = val;
    });
  }


  void onChangeRadioButton(val) {
    setState(() {
      radioGroupValue = val;
    });
  }

  void onChangeCheckBoxMenuItem(val) {
    setState(() {
      checkBoxMenuItem = val;
    });
  }
}
