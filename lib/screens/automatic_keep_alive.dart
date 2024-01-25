import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sample_latest/widgets/custom_app_bar.dart';

class AutomaticKeepAliveScreen extends StatefulWidget {
  const AutomaticKeepAliveScreen({Key? key}) : super(key: key);

  @override
  State<AutomaticKeepAliveScreen> createState() =>
      _AutomaticKeepAliveScreenState();
}

class _AutomaticKeepAliveScreenState extends State<AutomaticKeepAliveScreen> {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Tab 1'),
    Tab(text: 'Tab 2'),
  ];
  bool keepAliveStatus = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('Automatic Keep Alive'),
          bottom: const TabBar(
            tabs: myTabs,
            labelColor: Colors.white,
            indicatorColor: Colors.red,
            dividerColor: Colors.orange,
            // unselectedLabelColor: Colors.white,
          ),
          appBar: AppBar(),
        ),
        body: Column(
          children: [
            const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                    "Scroll the list items and then switch between the Tabs, List items still persists in the same location,"
                    " this is due to AutomaticKeepAlive, when you set the wantKeepAlive status to true, it will kept the widget alive", style: TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.w600
                ),)),
            // Switch(
            //     value: keepAliveStatus,
            //     onChanged: (value) {
            //       setState(() {
            //         keepAliveStatus = value;
            //       });
            //     }),
            Expanded(
              child: TabBarView(
                children: myTabs.map((Tab tab) {
                  final String label = tab.text!.toLowerCase();
                  return ListData(label, keepAliveStatus);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}

class ListData extends StatefulWidget {
  final String text;
  final bool keepAliveStatus;
  const ListData(this.text, this.keepAliveStatus, {Key? key}) : super(key: key);

  @override
  State<ListData> createState() => _ListDataState();
}

class _ListDataState extends State<ListData>
    with AutomaticKeepAliveClientMixin<ListData> {

  @override
  bool get wantKeepAlive => widget.keepAliveStatus;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(100, (index) {
      var random = Random().nextInt(40000);
      return ListTile(
        title: Text('$index Data $random'),
        leading: Icon(getRandomIcon(), color: Theme.of(context).iconTheme.color),
      );
    }));
  }

  IconData getRandomIcon(){
    final List<int> points = <int>[0xe0b0, 0xe0b1, 0xe0b2, 0xe0b3, 0xe0b4];
    final Random random = Random();
    const String chars = '0123456789ABCDEF';
    int length = 3;
    String hex = '0xe';
    while(length-- > 0) hex += chars[(random.nextInt(16)) | 0];
    return IconData(int.parse(hex), fontFamily: 'MaterialIcons');
  }
}
