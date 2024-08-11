import 'package:flutter/material.dart';

class TodayEventsView extends StatefulWidget {

  const TodayEventsView({super.key});

  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<TodayEventsView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<String> _items;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;
  @override
  void initState() {
    super.initState();
    _items = [];
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start the animation

    _addItemsWithDelay();
  }

  Future<void> _addItemsWithDelay() async {
    const items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

    for (var i = 0; i < items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      _items.insert(i, items[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 0.0,
          child: Material(
            color: Colors.white.withOpacity(0.8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Border radius
              child: ListTile(
                onTap: (){},
                enabled: true,
                selectedTileColor: Colors.blue,
                selectedColor: Colors.lightGreen,

                horizontalTitleGap: 3,
                isThreeLine: true,
                title: Text(_items[index]),
                leading: Icon(Icons.star),
                trailing: Icon(Icons.accessibility),
                subtitle: Text('sdfds sdfsdf dsf dsfd sfds fds df'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - 200,
      width: size.width - 100,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Today Events', style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                  flex: 1,
                  child: AnimatedList(
                      key: _listKey,
                      shrinkWrap: true,
                      initialItemCount: _items.length,
                      itemBuilder: (context, index, animation) {
                        return _buildItem(context, index, animation);
                      },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: SizeTransition(
                sizeFactor: _sizeAnimation,
                axisAlignment: 0.0,
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}