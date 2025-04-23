import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';
import 'package:sample_latest/features/daily_tracker/features/users/presentation/cubit/profiles_cubit.dart';

import '../../../../../core/mixins/date_formats.dart';
import '../../../../../core/mixins/dialogs.dart';
import '../../../../../core/mixins/validators.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../shared/params/profile_params.dart';

class CreateOrEditProfile extends StatefulWidget {
  final BuildContext parentContext;
  final ProfileEntity? profileEntity;
  const CreateOrEditProfile(this.parentContext,
      {this.profileEntity, super.key});

  @override
  State<CreateOrEditProfile> createState() => _CreateOrEditProfileState();
}

class _CreateOrEditProfileState extends State<CreateOrEditProfile>
    with CustomDialogs, Validators, DateFormats {
  final TextEditingController nameCtrl = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isCreateEvent = true;

  var actions = <TextEditingController>[];

  @override
  void initState() {
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
              controller: nameCtrl,
              label: 'Enter Profile name',
              suffixIcon: const Icon(Icons.title),
              validator: (val) =>
                  textEmptyValidator(val, 'Profile name required'),
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
          var params =
              ProfileParams(nameCtrl.text.trim(), id: widget.profileEntity?.id);
          widget.parentContext
              .read<ProfilesCubit>()
              .createOrEditProfile(params);
          GoRouter.of(context).pop();
        }
        break;
    }
  }
}
