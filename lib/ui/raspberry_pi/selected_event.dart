import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:sample_latest/mixins/date_formats.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:sample_latest/models/daily_tracker/action_event.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../utils/enums_type_def.dart';

class SelectedEventView extends StatefulWidget {
  final DailyTrackerEventModel selectedEvent;
  final ValueChanged<EventActionType> callBack;

  const SelectedEventView(this.selectedEvent, this.callBack, {super.key});

  @override
  State<SelectedEventView> createState() => _SelectedEventViewState();
}

class _SelectedEventViewState extends State<SelectedEventView> with DateFormats{
  late EventStatus eventStatus;
  late StopWatchTimer _stopWatchTimer;

  @override
  void initState() {
    eventStatus = HelperMethods.enumFromString(
            EventStatus.values, widget.selectedEvent.status) ??
        EventStatus.pending;

    if(eventStatus == EventStatus.inProgress && widget.selectedEvent.startDateTime != null) {
      var milliSeconds = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(widget.selectedEvent.startDateTime!)).inMilliseconds;
      _stopWatchTimer = StopWatchTimer(
          presetMillisecond : milliSeconds
      ); // Create instance.
      _stopWatchTimer.onStartTimer();
    }else{
      _stopWatchTimer = StopWatchTimer();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SelectedEventView oldWidget) {
    eventStatus = HelperMethods.enumFromString(
        EventStatus.values, widget.selectedEvent.status) ??
        EventStatus.pending;
    _stopWatchTimer.clearPresetTime();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetails(),
          widget.selectedEvent.eventType != EventDayType.action.name ? _buildStartAndEnd() : _buildActionCheckList(),
          _buildActions()],
      ),
    );
  }

  Widget _buildDetails() {
    var labelStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    var valueStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FixedColumnWidth(20),
        2: FlexColumnWidth(3),
      },
      children: [
        TableRow(children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Title', style: labelStyle)),
          Text(':'),
          Text(widget.selectedEvent.title, style: valueStyle)
        ]),
        TableRow(children: [
          Text('Description', style: labelStyle),
          const Text(':'),
          Text(widget.selectedEvent.description, style: valueStyle)
        ]),
        if(eventStatus == EventStatus.completed) TableRow(children: [
          Text('Duration', style: labelStyle),
          const Text(':'),
          Text(durationBetweenTwoDates(widget.selectedEvent.startDateTime, widget.selectedEvent.endDateTime), style: valueStyle)
        ]),
      ],
    );
  }

  Widget _buildActionCheckList() {
     return LayoutBuilder(
       builder: (context, constraints) {
         return Align(
           alignment: Alignment.topLeft,
           child: Wrap(
             crossAxisAlignment: WrapCrossAlignment.start,
             alignment: WrapAlignment.start,
             runSpacing: 10,
             children: widget.selectedEvent.actionCheckList.map((e)=> SizedBox(
                 width: constraints.maxWidth/2,
                 child: CheckboxListTile(
                     value: e.isSelected,title: Text(e.label), onChanged: (value) => onActionSelection(value, e)))).toList()
           ),
         );
       }
     );
  }

  Widget _buildStartAndEnd() {
    var color = rippleColor;
    return RippleAnimation(
      color: color,
      delay: const Duration(milliseconds: 300),
      repeat: true,
      minRadius: 75,
      ripplesCount: 6,
      duration: const Duration(milliseconds: 6 * 300),
      child: ColoredBox(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onTimerStartOrStop,
          child: Container(
              height: 150,
              width: 150,
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Container(
                alignment: Alignment.center,
                decoration:
                BoxDecoration(color: color.withOpacity(0.5), shape: BoxShape.circle),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    _buildTimer(),
                    Text(
                        eventStatusTitle,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return StreamBuilder<int>(
        stream: _stopWatchTimer.rawTime,
        initialData: _stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          final value = snap.data!;
          final displayTime =
          StopWatchTimer.getDisplayTime(value, hours: false, milliSecond: false);
          return Text(displayTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
        });
  }

  Widget _buildActions() {
    var isIgnore = eventStatus == EventStatus.completed || eventStatus == EventStatus.skip;

    return Wrap(
      spacing: 10,
      children: [
        ElevatedButton.icon(
            onPressed: isIgnore ? null : () => widget.callBack(EventActionType.skip),
            label: const Text('Skip'),
            icon: const Icon(Icons.delete)),
        ElevatedButton.icon(
            onPressed: isIgnore ? null : () => widget.callBack(EventActionType.edit),
            label: const Text('Edit'),
            icon: const Icon(Icons.edit)),
        ElevatedButton.icon(
            onPressed: isIgnore ? null : () => widget.callBack(EventActionType.completed),
            label: const Text('Complete'),
            icon: const Icon(Icons.disc_full)),
      ],
    );
  }

  void onActionSelection(bool? value, ActionEventModel event) {
    setState(() {
      event.isSelected = value ?? false;
    });
  }

  void onTimerStartOrStop() {

    if(eventStatus == EventStatus.pending) {
      _stopWatchTimer.onStartTimer();
      setState(() {
        eventStatus = EventStatus.inProgress;
        widget.selectedEvent.status = EventStatus.inProgress.name;
      });
      widget.callBack(EventActionType.inProgress);
    }else{
      _stopWatchTimer.onStopTimer();
      setState(() {
        eventStatus = EventStatus.completed;
        widget.selectedEvent.status = EventStatus.completed.name;
      });
      widget.callBack(EventActionType.completed);
    }
  }

  String get eventStatusTitle {
    return switch(eventStatus){
      EventStatus.inProgress => 'End',
      EventStatus.pending => 'Start',
      EventStatus.completed => 'Completed',
      EventStatus.skip => 'Omitted',
    };
  }

  Color get rippleColor {
    return switch(eventStatus){
      EventStatus.inProgress => Colors.orange,
      EventStatus.pending => Colors.blue,
      EventStatus.completed => Colors.green,
      EventStatus.skip => Colors.red,
    };
  }
}
