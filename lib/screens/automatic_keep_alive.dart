

import 'dart:math';

import 'package:flutter/material.dart';

class AutomaticKeepAliveScreen extends StatefulWidget {
  const AutomaticKeepAliveScreen({Key? key}) : super(key: key);

  @override
  State<AutomaticKeepAliveScreen> createState() => _AutomaticKeepAliveScreenState();
}

class _AutomaticKeepAliveScreenState extends State<AutomaticKeepAliveScreen> with AutomaticKeepAliveClientMixin<AutomaticKeepAliveScreen> {

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  @override
  void dispose() {
    print('## dispose called');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: myTabs.map((Tab tab) {
            final String label = tab.text!.toLowerCase();
            return ListData(label);
          }).toList(),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


class ListData extends StatefulWidget {
  final String text;
  const ListData(this.text, {Key? key}) : super(key: key);

  @override
  State<ListData> createState() => _ListDataState();
}

class _ListDataState extends State<ListData> with AutomaticKeepAliveClientMixin<ListData>{

  bool keepAliveStatus = true;
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => keepAliveStatus;
  @override
  Widget build(BuildContext context) {
    print(widget.text);
    return Column(
      children: [
        ElevatedButton(onPressed: () => setState(() {
          keepAliveStatus = false;
          updateKeepAlive(); /// once keep alive status is called need to call this method mandatory
        }),
            child: Text('presee')),
        Expanded(
          child: ListView(
              children: List.generate(100, (index) {
                var random = Random().nextInt(40000);
                return ListTile(
                  title:  Text('$index helooo $random'),
                  trailing: Icon(Icons.add),
                );
              })
          ),
        ),
      ],
    );
  }
}

