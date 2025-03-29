import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/schools/data/model/school_model.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/validators.dart';
import 'package:sample_latest/core/widgets/custom_dropdown.dart';
import 'package:sample_latest/core/widgets/text_field.dart';

import '../../../shared/models/school_view_model.dart';
import '../../../shared/params/school_params.dart';
import '../../blocs/schools_bloc/schools_bloc.dart';

class CreateSchool extends StatefulWidget {
  final SchoolViewModel? school;
  final BuildContext parentContext;
  const CreateSchool({Key? key,  required this.parentContext, this.school}) : super(key: key);

  @override
  State<CreateSchool> createState() => _CreateSchoolState();
}

class _CreateSchoolState extends State<CreateSchool>
    with CustomDialogs, Validators {
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

  bool isCreateSchool = true;

  @override
  void initState() {
    if (widget.school != null) {
      schoolNameCtrl.text = widget.school?.schoolName ?? '';
      locationCtrl.text = widget.school?.location ?? '';
      selectedCountry = widget.school?.country;

      isCreateSchool = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Create School',
        content: _buildFrom(),
        actions: ['Cancel', isCreateSchool ? 'Create' : 'Update'],
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
              controller: schoolNameCtrl,
              label: 'School Name',
              suffixIcon: const Icon(Icons.school),
              validator: (val) =>
                  textEmptyValidator(val, 'School name is required!!'),
            ),
            CustomDropDown(
              items: countries
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => selectedCountry = val,
              value: selectedCountry,
              hint: 'Select Country',
              validator: (val) =>
                  textEmptyValidator(val, 'Country is required!!'),
            ),
            CustomTextField(
              controller: locationCtrl,
              label: 'Location Name',
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
        GoRouter.of(context).pop();
        break;
      case 1:
        if (formKey.currentState?.validate() ?? false) {
          widget.parentContext.read<SchoolsBloc>().createOrUpdateSchool(
              SchoolParams(schoolNameCtrl.text.trim(), selectedCountry!,
                  locationCtrl.text.trim(), widget.school?.id),
              isCreateSchool: isCreateSchool);
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}
