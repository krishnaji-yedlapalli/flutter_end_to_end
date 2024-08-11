
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/helper_methods.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';
import 'package:sample_latest/widgets/text_field.dart';

import '../../bloc/daily_status_tracker/daily_status_tracker_bloc.dart';

class CreateDailyTrackerEvent extends StatefulWidget {
  final DailyTrackerEventModel? event;
  const CreateDailyTrackerEvent({this.event, super.key});

  @override
  State<CreateDailyTrackerEvent> createState() =>
      _CreateDailyTrackerEventState();
}

class _CreateDailyTrackerEventState extends State<CreateDailyTrackerEvent>
    with CustomDialogs, Validators {
  final TextEditingController titleCtrl = TextEditingController();

  final TextEditingController descriptionCtrl = TextEditingController();

  final TextEditingController selectedDateCtrl = TextEditingController();

  final TextEditingController selectedTimeCtrl = TextEditingController();

  static const Map<String, EventDayType> eventTypes = {
    'Every day': EventDayType.everyday,
    'Day by day': EventDayType.dayByDay,
    'Weekly': EventDayType.weekly,
    'Fort Night': EventDayType.fortnight,
    'Quarterly': EventDayType.quaterly,
    'Custom Date': EventDayType.customDate
  };

  static const Map<String, PartsOfDay> partOfDay = {
    'All Day': PartsOfDay.allDay,
    'Morning': PartsOfDay.morning,
    'Afternoon': PartsOfDay.afternoon,
    'Evening': PartsOfDay.evening,
    'Night': PartsOfDay.night,
    'Custom Time': PartsOfDay.customTime
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late EventDayType selectedEvent;

  late PartsOfDay selectedPartOfDay;

  String? selectedDate;

  String? selectedTime;

  bool isCreateEvent = true;

  @override
  void initState() {
    selectedEvent = eventTypes.entries.first.value;
    selectedPartOfDay = partOfDay.entries.first.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Create Event',
        content: _buildFrom(),
        actions: ['Cancel', isCreateEvent ? 'Create' : 'Update'],
        callBack: onTapOfAction);
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
              validator: (val) =>
                  textEmptyValidator(val, 'School name is required!!'),
            ),
            CustomTextField(
              controller: descriptionCtrl,
              label: 'Description',
              suffixIcon: const Icon(Icons.description),
              validator: (val) =>
                  textEmptyValidator(val, 'Location is required!!'),
            ),
            CustomDropDown(
              items: eventTypes.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: onSelectionOfEventType,
              value: selectedEvent,
              hint: 'Event Type',
              validator: (val) =>
                  textEmptyValidator(val?.toString(), 'Event Type is required!!'),
            ),
            if (selectedEvent != EventDayType.everyday)
              Wrap(
                spacing: 10,
                runSpacing: 20,
                children: [
                  CustomTextField(
                    controller: selectedDateCtrl,
                    label: 'Select Date',
                    validator: (val) =>
                        textEmptyValidator(val, 'Date is required!!'),
                    suffixIcon : IconButton(icon: Icon(Icons.calendar_month), onPressed: onSelectionOfDate),
                  ),
                  CustomDropDown(
                    items: partOfDay.entries
                        .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                        .toList(),
                    onChanged: onSelectionOfPartOfDay,
                    value: selectedPartOfDay,
                    hint: 'Time of Day',
                    validator: (val) =>
                        textEmptyValidator(val?.toString(), 'Time of day is required!!'),
                  ),
                  if(selectedPartOfDay == PartsOfDay.customTime)
                  Wrap(
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      CustomTextField(
                        controller: selectedTimeCtrl,
                        label: 'Select Time',
                        validator: (val) =>
                            textEmptyValidator(val, 'Time is required!!'),
                        suffixIcon : IconButton(icon: Icon(Icons.timer), onPressed: onSelectionOfTime),
                      ),
                    ],
                  )
                ],
              )
          ],
        ),
      ),
    );
  }

  void onSelectionOfEventType(EventDayType? val) {
    if (val != null) {
      setState(() {
        selectedEvent = val;
      });
    }
  }

  void onSelectionOfPartOfDay(PartsOfDay? val) {
    if (val != null) {
      setState(() {
        selectedPartOfDay = val;
      });
    }
  }

  void onSelectionOfDate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
        selectedDate = pickedDate.toString();
        selectedDateCtrl.text = pickedDate.toString();
    });
  }

  void onSelectionOfTime() async {
    TimeOfDay? timeOfDay = await  showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if(timeOfDay != null){
      selectedTime =  timeOfDay.format(context);
      selectedTimeCtrl.text = timeOfDay.format(context);
    }
  }

  void onTapOfAction(int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).pop();
        break;
      case 1:
        if (formKey.currentState?.validate() ?? false) {
          context
              .read<DailyTrackerStatusBloc>()
              .createOrUpdateEvent(DailyTrackerEventModel(
                isCreateEvent ? HelperMethods.uuid : widget.event!.id,
                selectedEvent.name,
                titleCtrl.text.trim(),
                descriptionCtrl.text.trim(),
                widget.event?.createdDate ??
                    DateTime.now().millisecondsSinceEpoch,
                DateTime.now().millisecondsSinceEpoch,
                updatedDate: DateTime.now().millisecondsSinceEpoch,
              ));
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}
