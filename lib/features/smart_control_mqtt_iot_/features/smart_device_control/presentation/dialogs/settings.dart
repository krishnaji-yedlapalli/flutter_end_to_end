import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/validators.dart';
import 'package:sample_latest/core/widgets/text_field.dart';
import 'package:sample_latest/features/schools/presentation/blocs/school_details_bloc/school_details_bloc.dart';

import '../../../../../../core/widgets/custom_dropdown.dart';
import '../../../../shared/models/smart_control_model.dart';
import '../cubit/smart_device_mqtt_control_cubit.dart';

class SmartDeviceSetting extends StatefulWidget {
  const SmartDeviceSetting(
      this.parentContext,
      this.smartControlMqttModel,
      {Key? key,
        })
      : super(key: key);

  final BuildContext parentContext;
  final SmartControlMqttModel smartControlMqttModel;

  @override
  State<SmartDeviceSetting> createState() => _SmartDeviceSettingState();
}

class _SmartDeviceSettingState extends State<SmartDeviceSetting>
    with CustomDialogs, Validators {

  static const List<(String, int)> time = [
  ('2 minutes', 2 * 60 * 1000),
  ('30 minutes', 30 * 60 * 1000),
  ('1 hour', 60 * 60 * 1000),
  ('2hr\'s', 120 * 60 * 1000),
  ('3hr\'s', 180 * 60 * 1000),
  ('5hr\'s', 300 * 60 * 1000),
  ('8hr\'s', 480 * 60 * 1000),
  ('12hr\'s', 720 * 60 * 1000),
  ('24hr\'s', 1440 * 60 * 1000),
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late int selectedTime;

  @override
  void initState() {
     selectedTime = widget.smartControlMqttModel.time ?? time.first.$2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Smart Device Settings',
        content: _buildFrom(),
        actions: ['Cancel', 'Update'],
        callBack: onTapOfAction);
  }

  Widget _buildFrom() {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        spacing: 10,
        children: [
          CustomDropDown<int>(
            items: time
                .map((e) => DropdownMenuItem<int>(value: e.$2, child: Text(e.$1)))
                .toList(),
            onChanged: (val){
              if(val != null){
                selectedTime = val;
              }
            },
            value: selectedTime,
            hint: 'Select Time',
            validator: (val) =>
                textEmptyValidator(val.toString(), 'Time is required!!'),
          ),
        ],
      )
    );
  }

  void onTapOfAction(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
      case 1:
        if (formKey.currentState?.validate() ?? false) {
          widget.parentContext.read<SmartDeviceMqttControlCubit>().onSelectionOfSetting(selectedTime);
          Navigator.of(context).pop();
        }
        break;
    }
  }
}
