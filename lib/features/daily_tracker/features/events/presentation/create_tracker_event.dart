import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/date_formats.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/validators.dart';
import 'package:sample_latest/features/daily_tracker/data/model/action_event.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:sample_latest/core/widgets/custom_dropdown.dart';
import 'package:sample_latest/core/widgets/text_field.dart';
import 'package:sample_latest/features/daily_tracker/features/events/presentation/cubit/events_cubit.dart';

import '../../../domain/entities/event_entity.dart';

class CreateDailyTrackerEvent extends StatefulWidget {
  final EventEntity? event;
  final BuildContext parentContext;
  const CreateDailyTrackerEvent(this.parentContext, {this.event, super.key});

  @override
  State<CreateDailyTrackerEvent> createState() =>
      _CreateDailyTrackerEventState();
}

class _CreateDailyTrackerEventState extends State<CreateDailyTrackerEvent>
    with CustomDialogs, Validators, DateFormats {
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
    'Custom Date': EventDayType.customDate,
    'Action Checklist': EventDayType.action
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

  DateTime? selectedDate;

  TimeOfDay? selectedTime;

  bool isCreateEvent = true;

  var actions = <TextEditingController>[];

  @override
  void initState() {
    selectedEvent = eventTypes.entries.first.value;
    selectedPartOfDay = partOfDay.entries.first.value;

    if (widget.event != null) {
      isCreateEvent = false;
      var selectedDateDetails =
          getDateFromMillisecondsSinceEpoch(widget.event!.selectedDateTime);
      selectedDate = selectedDateDetails.$1;
      selectedTime = selectedDateDetails.$2;

      titleCtrl.text = widget.event?.title ?? '';
      descriptionCtrl.text = widget.event?.description ?? '';
      selectedDateCtrl.text = formatDateToDDMMYY(selectedDate!);
      
      actions = widget.event!.actionCheckList.map((action)=> TextEditingController(text: action.label)).toList();
      WidgetsBinding.instance.addPostFrameCallback((duration) {
        selectedTimeCtrl.text = selectedTime?.format(context) ?? '';
      });
    } else {
      selectedDate = DateTime.now();
      selectedDateCtrl.text = formatDateToDDMMYY(selectedDate!);
      selectedTime = const TimeOfDay(hour: 00, minute: 00);
    }

    if(actions.isEmpty) {
      actions.add(TextEditingController());
    }

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
            Row(
              children: [
                Expanded(
                  child: CustomDropDown(
                    items: eventTypes.entries
                        .map((e) => DropdownMenuItem(
                            value: e.value, child: Text(e.key)))
                        .toList(),
                    onChanged: onSelectionOfEventType,
                    value: selectedEvent,
                    hint: 'Event Type',
                    validator: (val) => textEmptyValidator(
                        val?.toString(), 'Event Type is required!!'),
                  ),
                ),
                const SizedBox(width: 5),
                if (selectedEvent != EventDayType.action)
                  Expanded(
                    child: CustomTextField(
                      controller: selectedDateCtrl,
                      label: 'Select Date',
                      validator: (val) =>
                          textEmptyValidator(val, 'Date is required!!'),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_month),
                          onPressed: onSelectionOfDate),
                    ),
                  ),
              ],
            ),
            selectedEvent == EventDayType.action
                ? _buildActionCheck()
                : _buildReminder()
          ],
        ),
      ),
    );
  }

  Widget _buildActionCheck() {
    return Column(
      children: [
        Wrap(
          runSpacing: 10,
        children : actions
            .map((element) => CustomTextField(
                  controller: element,
                  label: 'Action',
                  validator: (val) =>
                      textEmptyValidator(val, 'Action is required!!'),
                ))
            .toList()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(onPressed: onAddOfAction, label: Text('Add Action')),
        )
      ],
    );
  }

  Widget _buildReminder() {
    return Row(
      children: [
        Expanded(
          child: CustomDropDown(
            items: partOfDay.entries
                .map(
                    (e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                .toList(),
            onChanged: onSelectionOfPartOfDay,
            value: selectedPartOfDay,
            hint: 'Time of Day',
            validator: (val) => textEmptyValidator(
                val?.toString(), 'Time of day is required!!'),
          ),
        ),
        if (selectedPartOfDay == PartsOfDay.customTime) SizedBox(width: 5),
        if (selectedPartOfDay == PartsOfDay.customTime)
          Expanded(
            child: CustomTextField(
              controller: selectedTimeCtrl,
              label: 'Select Time',
              validator: (val) => textEmptyValidator(val, 'Time is required!!'),
              suffixIcon: IconButton(
                  icon: Icon(Icons.timer), onPressed: onSelectionOfTime),
            ),
          )
      ],
    );
  }

  void onAddOfAction() {
    setState(() {
      actions.add(TextEditingController());
    });
  }

  void onSelectionOfEventType(EventDayType? val) {
    if (val != null) {
      selectedDateCtrl.text = formatDateToDDMMYY(DateTime.now());
      selectedDate = DateTime.now();
      setState(() {
        selectedEvent = val;
      });
    }
  }

  void onSelectionOfPartOfDay(PartsOfDay? val) {
    if (val != null) {
      selectedTime = switch (val) {
        PartsOfDay.allDay => const TimeOfDay(hour: 00, minute: 00),
        PartsOfDay.morning => const TimeOfDay(hour: 06, minute: 00),
        PartsOfDay.afternoon => const TimeOfDay(hour: 12, minute: 00),
        PartsOfDay.evening => const TimeOfDay(hour: 16, minute: 00),
        PartsOfDay.night => const TimeOfDay(hour: 21, minute: 00),
        PartsOfDay.customTime => const TimeOfDay(hour: 00, minute: 00),
      };

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
      selectedDate = pickedDate;
      selectedDateCtrl.text = formatDateToDDMMYY(pickedDate);
    });
  }

  void onSelectionOfTime() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (timeOfDay != null) {
      selectedTime = timeOfDay;
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
          var selectedDateTime =
              mergeDateTimeAndTimeOfDay(selectedDate!, selectedTime!);

          widget.parentContext.read<EventsCubit>().createOrUpdateEvent(
              EventEntity(
                id: widget.event?.id,
                eventType: selectedEvent.name,
                title: titleCtrl.text.trim(),
                description: descriptionCtrl.text.trim(),
                createdDate: widget.event?.createdDate ?? DateTime.now().millisecondsSinceEpoch,
                selectedDateTime: selectedDateTime.millisecondsSinceEpoch,
                actionCheckList: actions
                    .map((action) => ActionEventModel(action.text.trim(), false))
                    .toList(),
                updatedDate: DateTime.now().millisecondsSinceEpoch,
              )
          );
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}
