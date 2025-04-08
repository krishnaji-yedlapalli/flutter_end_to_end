
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCheckInStatus extends StatefulWidget {
  const UserCheckInStatus({super.key});

  @override
  State<UserCheckInStatus> createState() => _UserCheckInStatusState();
}

class _UserCheckInStatusState extends State<UserCheckInStatus> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return    BlocBuilder<Dail, SchoolsState>(
    //
    //     builder: (context, state) {
    //       if (state is SchoolsInfoInitial || state is SchoolsInfoLoading) {
    //         return circularLoader();
    //       } else if (state is SchoolsInfoLoaded) {
    //         return _buildRegisteredSchools(state.schools);
    //       } else if (state is SchoolDataError) {
    //         return ExceptionView(state.errorStateType);
    //       } else {
    //         return Container();
    //       }
    //     });
  }
}

