import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/user_entity.dart';
import 'package:sample_latest/features/daily_tracker/features/users/presentation/cubit/users_cubit.dart';

class UsersView extends StatelessWidget with Loaders {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UsersCubit>().loadExistingUsers();

    return BlocBuilder<UsersCubit, UsersState>(
        builder: (context, UsersState userState) {
      if (userState is UsersStateLoaded) {
        return _buildView(context, userState.users);
      } else {
        return circularLoader();
      }
    });
  }

  Widget _buildView(BuildContext context, List<UserEntity> users) {

    return ElevatedButton(onPressed: ()=> GoRouter.of(context).go('home/daily-tracker'), child: Text('GO'));
    if(users.isEmpty){
      return Card(
        child: Text('Create user'),
      );
    }

    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'asset/daily_tracker/auth/user_landscape_image.png'))),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          child: ListView(
            children: List.generate(
                4,
                (index) => ListTile(
                      title: Text('sdfds'),
                    )),
          ),
        ),
    );
  }
}
