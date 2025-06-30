import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/common/logger/debug_log.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/create_tracker_event.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/cubit/events_cubit.dart';
import 'package:sample_latest/features/daily_tracker/presentation/screens/reminders_actions_checklist.dart';
import 'package:sample_latest/features/daily_tracker/presentation/screens/selected_event.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';

import '../../features/events/presentation/widgets/no_events.dart';

class TodayEventsView extends StatefulWidget {
  final List<EventEntity> todayEvents;

  const TodayEventsView(this.todayEvents, {super.key});

  @override
   createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<TodayEventsView>
    with TickerProviderStateMixin, HelperWidget, CustomDialogs {
  late List<EventEntity> _reminders;
  late List<EventEntity> _actions;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;
  int selectedIndex = 0;
  late TabController controller;
  var tabChangeNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    LogData.print('## Today events lengths ${widget.todayEvents.length}');

    super.initState();
    setEvents();
    controller.addListener(() {
      selectedIndex = 0;
      tabChangeNotifier.value = controller.index;
    });
  }

  @override
  didUpdateWidget(state) {
    LogData.print('## did update widget - Today events lengths  ${widget.todayEvents.length}');

    if (state.todayEvents.isNotEmpty /*&&
        state.todayEvents.length != widget.todayEvents.length*/) {
      setEvents();
    }
    super.didUpdateWidget(state);
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Today Events',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                    flex: 1,
                    child: DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(
                              controller: controller,
                              dividerColor: Colors.orange,
                              indicatorColor: Colors.orange,
                              labelColor: Colors.orange,
                              unselectedLabelColor: Colors.white,
                              tabs: const [
                                Tab(text: 'Reminders'),
                                Tab(text: 'Action Checklist'),
                              ],
                            ),
                            Expanded(
                              child:
                                  TabBarView(controller: controller, children: [
                                ActionsChecklistView(
                                    key: const Key('0'),
                                    _reminders,
                                    onSelectionOfEvent),
                                ActionsChecklistView(
                                    key: const Key('1'),
                                    _actions,
                                    onSelectionOfEvent),
                              ]),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
          if (widget.todayEvents.isNotEmpty)
            Expanded(
              flex: 2,
              child: ValueListenableBuilder(
                valueListenable: tabChangeNotifier,
                builder: (context, value, child) => FadeTransition(
                  opacity: _opacityAnimation,
                  child: SizeTransition(
                    sizeFactor: _sizeAnimation,
                    axisAlignment: 0.0,
                    child: isNotEmpty(value) ?  SelectedEventView(
                        key: UniqueKey(),
                        value == 0
                            ? _reminders.elementAt(selectedIndex)
                            : _actions.elementAt(selectedIndex),
                        onDeleteOrEditOrComplete) : const NoEventsToDisplay(),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  bool isNotEmpty(int index) {
    return index == 0 ? selectedIndex < _reminders.length : selectedIndex < _actions.length;
  }

  void onDeleteOrEditOrComplete(EventActionType actionType) {
    var events = controller.index == 0 ? _reminders : _actions;
    switch (actionType) {
      case EventActionType.edit:
        adaptiveDialog(
            context,
            CreateDailyTrackerEvent(context,
                event: events.elementAt(selectedIndex)));
      case EventActionType.completed:
        events[selectedIndex]
          ..status = EventActionType.completed.name
          ..endDateTime = DateTime.now().millisecondsSinceEpoch;

        context
            .read<EventsCubit>()
            .updateTodayEventDetails(events[selectedIndex]);
        setState(() {});

      case EventActionType.skip:
        events[selectedIndex].status = actionType == EventActionType.completed
            ? EventStatus.completed.name
            : EventStatus.skip.name;

        /// updating status
        context
            .read<EventsCubit>()
            .updateTodayEventDetails(events[selectedIndex]);

        setState(() {});

      case EventActionType.inProgress:
        events[selectedIndex]
          ..status = EventActionType.inProgress.name
          ..startDateTime = DateTime.now().millisecondsSinceEpoch;

        context
            .read<EventsCubit>()
            .updateTodayEventDetails(events[selectedIndex]);
        setState(() {});
    }
  }

  void onSelectionOfEvent(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void setEvents() {
    controller = TabController(length: 2, vsync: this);

    _reminders = widget.todayEvents
        .where((e) => e.eventType != EventDayType.action.name)
        .toList();
    _actions = widget.todayEvents
        .where((e) => e.eventType == EventDayType.action.name)
        .toList();

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

    _controller.forward();
  }
}
