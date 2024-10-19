
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/loaders.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/ui/daily_tracker/create_tracker_event.dart';

import '../../bloc/daily_status_tracker/daily_status_tracker_bloc.dart';

class ExistingEventsView extends StatefulWidget {
  const ExistingEventsView({super.key});

  @override
  State<ExistingEventsView> createState() => _ExistingEventsViewState();
}

class _ExistingEventsViewState extends State<ExistingEventsView> with Loaders, CustomDialogs{

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<DailyTrackerStatusBloc>().fetchExistingEvents();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyTrackerStatusBloc, DailyStatusTrackerState>(
        buildWhen: (oldState, currentState) {
          return currentState.dailyStatusTrackerLoadedType ==
              DailyStatusTrackerLoadedType.events;
        },
        builder: (context, DailyStatusTrackerState trackState) {
          if (trackState is DailyStatusTrackerEvents) {
            return _buildEvents(trackState.events);
          } else {
            return circularLoader();
          }
        });
  }

  Widget _buildEvents(List<DailyTrackerEventModel> events) {
   return dialogWithButtons(
       title: 'Existing Events',
       content: _buildList(events), actions: ['Close', 'Create Event'], callBack: onClose
   );
  }

  Widget _buildList(List<DailyTrackerEventModel> events) {
    return ListView.builder(
        itemCount: events.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          var event = events.elementAt(index);
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.description),
            isThreeLine: true,
            trailing: Wrap(
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () => onEdit(event)),
                IconButton(icon: Icon(Icons.delete), onPressed: () => onDelete(event)),
              ],
            ),
          );
        });
  }

  void onClose(int index) {
    if(index == 0) {
      GoRouter.of(context).pop();
    }else if(index == 1){
      adaptiveDialog(context, const CreateDailyTrackerEvent());
    }
  }

  void onDelete(DailyTrackerEventModel event) {
    context.read<DailyTrackerStatusBloc>().deleteEvent(event);
  }

  void onEdit(DailyTrackerEventModel event){
    adaptiveDialog(context, CreateDailyTrackerEvent(event: event));
  }

}
