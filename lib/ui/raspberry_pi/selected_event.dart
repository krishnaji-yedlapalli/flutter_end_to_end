
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class SelectedEventView extends StatefulWidget {
  final DailyTrackerEventModel selectedEvent;

  const SelectedEventView(this.selectedEvent, {super.key});

  @override
  State<SelectedEventView> createState() => _SelectedEventViewState();
}

class _SelectedEventViewState extends State<SelectedEventView> {
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
          _buildStartAndEnd(),
        _buildActions()
      ],),
    );
  }

  Widget _buildDetails(){

    var labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
    );

    var valueStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300
    );

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0 : FlexColumnWidth(1),
        1 : FixedColumnWidth(20),
        2 : FlexColumnWidth(3),
      },
      children: [
        TableRow(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Title' , style: labelStyle)),
            Text(':'),
            Text('${widget.selectedEvent.title}', style: valueStyle)
          ]
        ),
        TableRow(
            children: [
              Text('Description', style: labelStyle),
              Text(':'),
              Text('${widget.selectedEvent.description}', style: valueStyle)
            ]
        ),
      ],
    );
  }

  Widget _buildStartAndEnd() {
    return  RippleAnimation(
      color: Colors.lightGreenAccent,
      delay: const Duration(milliseconds: 300),
      repeat: true,
      minRadius: 75,
      ripplesCount: 6,
      duration: const Duration(milliseconds: 6 * 300),
      child: InkResponse(
        onTap: (){},
        child: Container(
            height: 150,
            width: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                DigitalClock(
                    showSeconds: true,
                    isLive: true,
                    digitalClockTextColor: Colors.black,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    datetime: DateTime.now()),
                Text('Start', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ],
            )
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 10,
      children: [
        ElevatedButton.icon(onPressed: (){}, label : Text('Delete'), icon: Icon(Icons.delete)),
        ElevatedButton.icon(onPressed: (){}, label : Text('Edit'), icon: Icon(Icons.edit)),
        ElevatedButton.icon(onPressed: (){}, label : Text('Complete'), icon: Icon(Icons.disc_full)),
      ],
    );
  }
}
