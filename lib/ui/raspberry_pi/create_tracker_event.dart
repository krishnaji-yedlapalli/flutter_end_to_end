
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';
import 'package:sample_latest/widgets/text_field.dart';

import '../../bloc/daily_status_tracker/daily_status_tracker_bloc.dart';

class CreateDailyTrackerEvent extends StatefulWidget {
  final DailyTrackerEventModel? event;
  const CreateDailyTrackerEvent({this.event, super.key});

  @override
  State<CreateDailyTrackerEvent> createState() => _CreateDailyTrackerEventState();
}

class _CreateDailyTrackerEventState extends State<CreateDailyTrackerEvent> with CustomDialogs, Validators {

  final TextEditingController titleCtrl = TextEditingController();

  final TextEditingController descriptionCtrl = TextEditingController();

  final TextEditingController selectedDateCtrl = TextEditingController();

  static const List<String> eventTypes = [
    'Every day',
    'Day by day',
    'Weekly',
    'Fort Night',
    'Quarterly',
    'Custom Date'
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String selectedEvent;

  bool isCreateEvent = true;

  @override
  void initState() {
    selectedEvent = eventTypes.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Create Event',
        content: _buildFrom(), actions: ['Cancel', isCreateEvent ? 'Create' : 'Update'], callBack: onTapOfAction
    );
  }

  Widget _buildFrom() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 10,
          runSpacing: 20,
          children: [
            CustomTextField(
              controller: titleCtrl,
              label: 'Title Of Event',
              suffixIcon: const Icon(Icons.title),
              validator: (val)=> textEmptyValidator(val, 'School name is required!!'),
            ),
            CustomTextField(
              controller: descriptionCtrl,
              label: 'Description',
              suffixIcon: const Icon(Icons.description),
              validator: (val)=> textEmptyValidator(val, 'Location is required!!'),
            ),
            CustomDropDown(
              items: eventTypes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val){ if(val != null) selectedEvent = val;},
              value: selectedEvent,
              hint: 'Event Type',
              validator: (val)=> textEmptyValidator(val, 'Country is required!!'),
            ),
            if(selectedEvent == 'Custom Date')
              Wrap(
                children: [

                ],
              )
          ],
        ),
      ),
    );
  }

  void onTapOfAction(int index){
    switch(index){
      case 0 :
        GoRouter.of(context).pop();
        break;
      case 1 :
        if(formKey.currentState?.validate() ?? false) {
          context.read<DailyTrackerStatusBloc>().createOrUpdateEvent(
            DailyTrackerEventModel(
                isCreateEvent ? HelperMethods.uuid : widget.event!.id,
                selectedEvent,
                titleCtrl.text.trim(),
                descriptionCtrl.text.trim(),
                widget.event?.createdDate ?? DateTime.now().millisecondsSinceEpoch,
                DateTime.now().millisecondsSinceEpoch,
                updatedDate: DateTime.now().millisecondsSinceEpoch,

    )
          );
          GoRouter.of(context).pop();
        }
        break;
    }
  }


}
