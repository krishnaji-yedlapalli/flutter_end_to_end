
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/daily_tracker/data/model/daily_tracker_event_model.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/create_tracker_event.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/cubit/events_cubit.dart';

import '../../features/dashboard/presentation/cubit/daily_status_tracker_cubit.dart';

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
    return BlocBuilder<EventsCubit, EventsState>(
        builder: (context, EventsState trackState) {
          if (trackState is EventsStateLoaded) {
            return _buildEvents(trackState.events);
          } else {
            return circularLoader();
          }
        });
  }

  Widget _buildEvents(List<EventEntity> events) {
   return dialogWithButtons(
       title: 'Existing Events',
       content: _buildList(events), actions: ['Close', 'Create Event'], callBack: onClose
   );
  }

  Widget _buildList(List<EventEntity> events) {
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

  void onDelete(EventEntity event) {
    context.read<EventsCubit>().deleteEvent(event);
  }

  void onEdit(EventEntity event){
    adaptiveDialog(context, CreateDailyTrackerEvent(event: event));
  }

}
