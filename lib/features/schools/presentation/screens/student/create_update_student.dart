import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/validators.dart';
import 'package:sample_latest/core/widgets/custom_dropdown.dart';
import 'package:sample_latest/core/widgets/text_field.dart';
import 'package:sample_latest/features/schools/presentation/blocs/students_bloc/students_bloc.dart';
import 'package:sample_latest/features/schools/shared/models/student_view_model.dart';
import 'package:sample_latest/features/schools/shared/params/student_params.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent(this.parentContext, this.schoolId,
      {Key? key, this.student})
      : super(key: key);

  final String schoolId;
  final StudentViewModel? student;
  final BuildContext parentContext;

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent>
    with CustomDialogs, Validators {
  final TextEditingController studentNameCtrl = TextEditingController();

  final TextEditingController staffStrengthCtrl = TextEditingController();

  final TextEditingController studentLocationCtrl = TextEditingController();

  static const List<String> standard = [
    'LKG',
    'UKG',
    '1st Standard',
    '2nd Standard',
    '3rd Standard',
    '4th Standard',
    '5th Standard',
    '6th Standard',
    '7th Standard',
    '8th Standard',
    '9th Standard',
    '10th Standard'
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedStandard;

  bool isCreateStudent = true;

  @override
  void initState() {
    if (widget.student != null) {
      studentNameCtrl.text = widget.student?.studentName ?? '';
      studentLocationCtrl.text = widget.student?.studentLocation ?? '';
      selectedStandard = widget.student?.standard;

      isCreateStudent = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Create Student',
        content: _buildFrom(),
        actions: ['Cancel', widget.student != null ? 'Update' : 'Create'],
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
              controller: studentNameCtrl,
              label: 'Student Name',
              suffixIcon: const Icon(Icons.school),
              validator: (val) =>
                  textEmptyValidator(val, 'Student name is required!!'),
            ),
            CustomDropDown(
              items: standard
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => selectedStandard = val,
              value: selectedStandard,
              hint: 'Standard',
              validator: (val) =>
                  textEmptyValidator(val, 'Standard is required!!'),
            ),
            CustomTextField(
              controller: studentLocationCtrl,
              label: 'Location of Student',
              suffixIcon: const Icon(Icons.location_on),
              validator: (val) =>
                  textEmptyValidator(val, 'Location is required!!'),
            ),
          ],
        ),
      ),
    );
  }

  void onTapOfAction(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop();
        break;
      case 1:
        if (formKey.currentState?.validate() ?? false) {
          widget.parentContext.read<StudentsBloc>().createOrEditStudent(
              StudentParams(
                widget.student?.id,
                widget.schoolId,
                studentNameCtrl.text.trim(),
                studentLocationCtrl.text.trim(),
                selectedStandard!,
              ),
              isCreateStudent: isCreateStudent);
          Navigator.of(context).pop();
        }
        break;
    }
  }
}
