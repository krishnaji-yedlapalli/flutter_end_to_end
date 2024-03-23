
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/models/school/school_details_model.dart';
import 'package:sample_latest/models/school/school_model.dart';
import 'package:sample_latest/models/school/student_model.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';
import 'package:sample_latest/widgets/text_field.dart';

class AddSchoolDetails extends StatefulWidget {

  final SchoolDetailsModel? schoolDetails;

  final SchoolModel school;

  const AddSchoolDetails({Key? key, required this.school, this.schoolDetails}) : super(key: key);

  @override
  State<AddSchoolDetails> createState() => _AddSchoolDetailsState();
}

class _AddSchoolDetailsState extends State<AddSchoolDetails> with CustomDialogs, Validators{


  final TextEditingController studentStrengthCtrl = TextEditingController();

  final TextEditingController staffStrengthCtrl = TextEditingController();

  bool hostelAvailability = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {

    if(widget.schoolDetails != null){

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Add School Details',
        content: _buildFrom(), actions: ['Cancel', widget.schoolDetails != null ? 'Update' : 'Create'], callBack: onTapOfAction
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
          context.read<SchoolBloc>().add(CreateOrEditSchoolDetailsEvent(
              SchoolDetailsModel(
                  widget.school.id,
                  widget.school.schoolName,
                  widget.school.country,
                  widget.school.location,
                  'https://upload.wikimedia.org/wikipedia/commons/c/ce/Monroe_Township_High_School_Front_View.jpg',
                  int.parse(studentStrengthCtrl.text.trim()),
                  int.parse(staffStrengthCtrl.text.trim()),
              hostelAvailability,
              widget.schoolDetails?.createdDate ?? DateTime.now().millisecondsSinceEpoch,
              updatedDate: DateTime.now().millisecondsSinceEpoch
              )));
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}