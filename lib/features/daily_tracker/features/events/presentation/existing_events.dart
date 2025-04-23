import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/event_entity.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/create_tracker_event.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/cubit/events_cubit.dart';

class ExistingEventsView extends StatefulWidget {
  final BuildContext parentContext;

  const ExistingEventsView(this.parentContext, {super.key});

  @override
  State<ExistingEventsView> createState() => _ExistingEventsViewState();
}

class _ExistingEventsViewState extends State<ExistingEventsView>
    with Loaders, CustomDialogs {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.parentContext.read<EventsCubit>(),
      child: Builder(builder: (context) {
        context.read<EventsCubit>().loadEventsBasedOnTheUser();
        return BlocBuilder<EventsCubit, EventsState>(
            builder: (context, EventsState trackState) {
          if (trackState is EventsStateLoaded) {
            return _buildEvents(context, trackState.events);
          } else {
            return circularLoader();
          }
        });
      }),
    );
  }

  Widget _buildEvents(BuildContext context, List<EventEntity> events) {
    return dialogWithButtons(
        title: 'Existing Events',
        content: _buildList(context, events),
        actions: ['Close', 'Create Event'],
        callBack: onClose);
  }

  Widget _buildList(BuildContext context, List<EventEntity> events) {
    return ListView.builder(
        itemCount: events.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var event = events.elementAt(index);
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.description),
            isThreeLine: true,
            trailing: Wrap(
              children: [
                IconButton(
                    icon: const Icon(Icons.edit), onPressed: () => onEdit(event)),
                IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onDelete(context, event)),
              ],
            ),
          );
        });
  }

  void onClose(int index) {
    if (index == 0) {
      GoRouter.of(context).pop();
    } else if (index == 1) {
      adaptiveDialog(context, CreateDailyTrackerEvent(widget.parentContext));
    }
  }

  void onDelete(BuildContext context, EventEntity event) {
    context.read<EventsCubit>().deleteEvent(event);
  }

  void onEdit(EventEntity event) {
    adaptiveDialog(widget.parentContext,
        CreateDailyTrackerEvent(widget.parentContext, event: event));
  }
}
