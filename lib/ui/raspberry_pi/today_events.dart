import 'package:flutter/material.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/ui/raspberry_pi/selected_event.dart';

class TodayEventsView extends StatefulWidget {
  final List<DailyTrackerEventModel> todayEvents;

  const TodayEventsView(this.todayEvents, {super.key});

  @override
  _AnimatedListExampleState createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<TodayEventsView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<DailyTrackerEventModel> _items;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;
  late DailyTrackerEventModel selectedEvent;

  @override
  void initState() {
    super.initState();

    if(widget.todayEvents.isNotEmpty){
      selectedEvent = widget.todayEvents.first;
    }

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

  @override
  didUpdateWidget(state) {
    if(_items.length < state.todayEvents.length){
      var index = _items.length;
      _items.insert(index, widget.todayEvents[index]);
      _listKey.currentState?.insertItem(index);
    }
    super.didUpdateWidget(state);
  }

  Future<void> _addItemsWithDelay() async {

    for (var i = 0; i < widget.todayEvents.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      _items.insert(i, widget.todayEvents[i]);
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    var event = _items.elementAt(index);
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
                title: Text(event.title),
                leading: Icon(Icons.star),
                trailing: Icon(Icons.accessibility),
                subtitle: Text(event.description),
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
                child: SelectedEventView(selectedEvent),
              ),
            ),
          )
        ],
      ),
    );
  }
}