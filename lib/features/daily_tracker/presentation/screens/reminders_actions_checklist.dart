import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/mixins/date_formats.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/helper_methods.dart';
import 'package:sample_latest/core/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/features/daily_tracker/data/model/daily_tracker_event_model.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/create_tracker_event.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/cubit/events_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../domain/entities/event_entity.dart';

class ActionsChecklistView extends StatefulWidget {
  final List<EventEntity> todayEvents;
  final ValueChanged<int> callBack;

  const ActionsChecklistView(this.todayEvents, this.callBack, {super.key});

  @override
  State<ActionsChecklistView> createState() => _ActionsChecklistViewState();
}

class _ActionsChecklistViewState extends State<ActionsChecklistView>
    with SingleTickerProviderStateMixin, HelperWidget, CustomDialogs, DateFormats, AutomaticKeepAliveClientMixin<ActionsChecklistView>{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<EventEntity> _items;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;
  int selectedIndex = 0;

  @override
  void initState() {
    print('## init state ${widget.todayEvents.length}');

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

    WidgetsBinding.instance.addPostFrameCallback((duration){
      _addItemsWithDelay();
    });

  }

  @override
  didUpdateWidget(state) {
    addItemsNewItems();
    super.didUpdateWidget(state);
  }

  Future<void> addItemsNewItems() async {
    for( var event in widget.todayEvents) {
      var index = _items.indexWhere((displayedEvent) => event.id == displayedEvent.id);

      if(index == -1){
        var length = _items.length;
        _items.insert(length, event);
        await Future.delayed(const Duration(milliseconds: 300));
        _listKey.currentState?.insertItem(length);

      }
    }
    print(_items.length);
  }

  Future<void> _addItemsWithDelay() async {
    for (var i = 0; i < widget.todayEvents.length; i++) {
      _items.insert(i, widget.todayEvents[i]);
      await Future.delayed(const Duration(milliseconds: 300));
      _listKey.currentState?.insertItem(i);
    }

    print(_items.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height - 200,
      width: size.width - 100,
      child: widget.todayEvents.isEmpty
          ? emptyMessage('No Events')
          : AnimatedList(
        key: _listKey,
        shrinkWrap: true,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(context, index, animation);
        },
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
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
            child: _buildListItem(event, index),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(EventEntity event, int index) {
    bool isSelected = selectedIndex == index;
    var statusConfig = geStatus(event.status, isSelected: isSelected);
    var time = getDateFromMillisecondsSinceEpoch(event.selectedDateTime).$2.format(context);
    var listItem = ListTile(
      onTap: () => onSelectionOfEvent(index),
      enabled: true,
      selected: isSelected,
      selectedTileColor: Colors.green,
      selectedColor: Colors.black,
      horizontalTitleGap: 3,
      isThreeLine: false,
      title: Text(event.title, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
      leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: const Icon(Icons.event)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: statusConfig.bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: statusConfig.borderColor)
        ),
        child: Text(statusConfig.label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
      ),
      subtitle: RichText(text: TextSpan(
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        children: [
          TextSpan(text: event.description),
          const TextSpan(text: ' - '),
          TextSpan(text: time == '12:00 AM' ? 'All day' : time),
        ]
      ))
    );

    return event.status != EventStatus.inProgress.name ? listItem : Shimmer.fromColors(
      baseColor: Colors.red,
      highlightColor: Colors.yellow,
      child: listItem,
    );
  }

  void onDeleteOrEditOrComplete(EventActionType actionType) {
    switch (actionType) {
      case EventActionType.edit:
        adaptiveDialog(
            context,
            CreateDailyTrackerEvent(
                event: _items.elementAt(selectedIndex)));
      case EventActionType.completed:

        _items[selectedIndex]..status = EventActionType.completed.name
          ..endDateTime = DateTime.now().millisecondsSinceEpoch;

        context.read<EventsCubit>().updateTodayEventDetails(_items[selectedIndex]);
        setState(() {

        });

      case EventActionType.skip:
        _items[selectedIndex].status =
        actionType == EventActionType.completed
            ? EventStatus.completed.name
            : EventStatus.skip.name;

        /// updating status
        context.read<EventsCubit>().updateTodayEventDetails(_items[selectedIndex]);

        setState(() {

        });

      case EventActionType.inProgress:
        _items[selectedIndex]..status = EventActionType.inProgress.name
          ..startDateTime = DateTime.now().millisecondsSinceEpoch;

        context.read<EventsCubit>().updateTodayEventDetails(_items[selectedIndex]);
        setState(() {

        });
    }
  }

  void onSelectionOfEvent(int index) {
    selectedIndex = index;
    widget.callBack(index);
    // setState(() {
    // });
  }

  ({String label, Color borderColor, Color bgColor}) geStatus(String status, {bool isSelected = false}) {
    EventStatus? eventStatus = HelperMethods.enumFromString(EventStatus.values, status);

    return switch(eventStatus){
      EventStatus.pending => (label : 'Pending', borderColor : isSelected ? Colors.white : Colors.blue, bgColor : Colors.blue.withOpacity(0.3)),
      EventStatus.inProgress  => (label : 'InProgress', borderColor : isSelected ? Colors.white : Colors.orange, bgColor : Colors.orange.withOpacity(0.3)),
      EventStatus.completed  => (label : 'Completed', borderColor : isSelected ? Colors.white : Colors.green, bgColor : isSelected ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.3)),
      EventStatus.skip  => (label : 'Omitted', borderColor : Colors.red, bgColor : Colors.red.withOpacity(0.3)),
      _ => (label : 'Omitted', borderColor : Colors.red, bgColor : Colors.red.withOpacity(0.3))
    };
  }

  @override
  bool get wantKeepAlive => true;
}

