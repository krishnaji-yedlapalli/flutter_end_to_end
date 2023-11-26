
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/helper_widgets_mixin.dart';

class CupertinoComponents extends StatefulWidget {
  const CupertinoComponents({Key? key}) : super(key: key);

  @override
  State<CupertinoComponents> createState() => _CupertinoComponentsState();
}

class _CupertinoComponentsState extends State<CupertinoComponents> with HelperWidget  {

   List<String> _fruitNames = <String>[
    'Apple',
    'Mango',
    'Banana',
    'Orange',
    'Pineapple',
    'Strawberry',
  ];
   double _kItemExtent = 32.0;
   int _selectedFruit = 0;


   @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          spacing: 50,
          runSpacing: 50,
          children: [
            _buildActivityIndicator(),
            vDivider,
            _buildCupertinoAlertDialog(),
            vDivider,
            _cupertinoContextMenu(),
            vDivider,
            _cupertinoPicker()
          ],
        ),
      ),
    );
  }

  Widget _buildActivityIndicator() {
    return buildTitleWithContent(
      title: 'Cupertino Activity Indicator',
      content:CupertinoActivityIndicator(),
    );
  }

  Widget _buildCupertinoAlertDialog() {
    return buildTitleWithContent(
      title: 'Cupertino Alert Dialog',
      content: CupertinoButton(child: const Text('Alert Dialog'), onPressed: _showAlertDialog),
    );
  }

  void _showAlertDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Proceed with destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }


  Widget _cupertinoContextMenu() {
    return  buildTitleWithContent(
      title: 'Cupertino Text Menu action',
      content:  CupertinoContextMenu(actions: [
        CupertinoContextMenuAction(child: const Text('Copy'), onPressed: () => GoRouter.of(context).pop()),
        CupertinoContextMenuAction(child: const Text('Paste'), onPressed: () => GoRouter.of(context).pop()),
      ],
       enableHapticFeedback: true,
          child: RichText(text: TextSpan(text: 'Menu Item')))
    );
  }

  Widget _cupertinoPicker() {
    return  buildTitleWithContent(
        title: 'Cupertino Picker',
        content: Wrap(
          spacing: 10,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CupertinoButton(onPressed: _showCupertinoPicker, child: const Text('Open cupertino Picker')),
            Text(_fruitNames.elementAt(_selectedFruit), style: Theme.of(context).textTheme.titleSmall)
          ],
        )
    );
  }

  void _showCupertinoPicker() {
    showCupertinoModalPopup(context: context, builder: (context) {
      return SizedBox(
        height: 216,
        child: CupertinoPicker(
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: _kItemExtent,
          // This sets the initial item.
          scrollController: FixedExtentScrollController(
            initialItem: _selectedFruit,
          ),
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            setState(() {
              _selectedFruit = selectedItem;
            });
          },
          children:
          List<Widget>.generate(_fruitNames.length, (int index) {
            return Center(child: Text(_fruitNames[index]));
          }),
        ),
      );
    });
  }

}
