
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/data/models/school/student_model.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';
import 'package:sample_latest/widgets/text_field.dart';

class CreateStudent extends StatefulWidget {
  final int schoolId;
  const CreateStudent(this.schoolId, {Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _CreateStudentState();
}

class _CreateStudentState extends State<CreateStudent> with CustomDialogs, Validators{

  final TextEditingController studentNameCtrl = TextEditingController();

  final TextEditingController studentStrengthCtrl = TextEditingController();

  final TextEditingController staffStrengthCtrl = TextEditingController();

  final TextEditingController studentLocationCtrl = TextEditingController();

  bool hostelAvailability = false;

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

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Create Student',
        content: _buildFrom(), actions: ['Cancel', 'Create'], callBack: onTapOfAction
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
              controller: studentNameCtrl,
              label: 'Student Name',
              suffixIcon: const Icon(Icons.school),
              validator: (val)=> textEmptyValidator(val, 'Student name is required!!'),
            ),
            CustomDropDown(
              items: standard
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => selectedStandard = val,
              value: selectedStandard,
              hint: 'Standard',
              validator: (val)=> textEmptyValidator(val, 'Standard is required!!'),
            ),
            CustomTextField(
              controller: studentStrengthCtrl,
              label: 'Student Strength',
              suffixIcon: const Icon(Icons.child_care),
              inputFormatter: [Validators.onlyNumerics],
              validator: (val)=> textEmptyValidator(val, 'Strength is required!!'),
            ),
            CustomTextField(
              controller: staffStrengthCtrl,
              label: 'Staff Strength',
              suffixIcon: const Icon(Icons.person),
              inputFormatter: [Validators.onlyNumerics],
              validator: (val)=> textEmptyValidator(val, 'Strength is required!!'),
            ),
            CustomTextField(
              controller: studentLocationCtrl,
              label: 'Location of Student',
              suffixIcon: const Icon(Icons.location_on),
              validator: (val)=> textEmptyValidator(val, 'Location is required!!'),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 5,
              children: [
                Text('Hostel Availability :'),
                Switch.adaptive(value: hostelAvailability, onChanged: (val) =>  hostelAvailability = val)
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
          context.read<SchoolBloc>().add(CreateStudentEvent(
              StudentModel(
                widget.schoolId,
                studentNameCtrl.text.trim(),
                selectedStandard!,
                int.parse(studentStrengthCtrl.text.trim()),
                int.parse(staffStrengthCtrl.text.trim()),
                studentLocationCtrl.text.trim(),
                hostelAvailability,
                selectedStandard!
              ), widget.schoolId));
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}