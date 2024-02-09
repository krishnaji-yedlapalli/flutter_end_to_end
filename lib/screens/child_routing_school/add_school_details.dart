
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/bloc/school/school_bloc.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/validators.dart';
import 'package:sample_latest/widgets/custom_dropdown.dart';
import 'package:sample_latest/widgets/text_field.dart';

class AddSchoolDetails extends StatefulWidget {
  const AddSchoolDetails({Key? key}) : super(key: key);

  @override
  State<AddSchoolDetails> createState() => _AddSchoolDetailsState();
}

class _AddSchoolDetailsState extends State<AddSchoolDetails> with CustomDialogs, Validators{

  final TextEditingController schoolNameCtrl = TextEditingController();

  final TextEditingController locationCtrl = TextEditingController();

  static const List<String> countries = [
    'India',
    'USA',
    'UK',
    'Russia',
    'Dubai',
    'China',
    'Japan'
  ];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Create School',
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
              controller: schoolNameCtrl,
              label: 'School Name',
              suffixIcon: const Icon(Icons.school),
              validator: (val)=> textEmptyValidator(val, 'School name is required!!'),
            ),
            CustomDropDown(
              items: countries
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (val) => selectedCountry = val,
              value: selectedCountry,
              hint: 'Select Country',
              validator: (val)=> textEmptyValidator(val, 'Country is required!!'),
            ),
            CustomTextField(
              controller: locationCtrl,
              label: 'Location Name',
              suffixIcon: const Icon(Icons.location_on),
              validator: (val)=> textEmptyValidator(val, 'Location is required!!'),
            ),
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
          context.read<SchoolBloc>().add(CreateSchoolEvent(
              schoolNameCtrl.text.trim(), selectedCountry!,
              locationCtrl.text.trim()));
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}