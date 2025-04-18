import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/device/widgets/adapative_container.dart';
import 'package:sample_latest/core/device/widgets/adapative_padding.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/features/daily_tracker/domain/entities/profile_entity.dart';
import 'package:sample_latest/features/daily_tracker/features/users/presentation/cubit/profiles_cubit.dart';

import '../../../shared/models/profile_executed_task.dart';
import '../../greetings/presentation/cubit/check_in_status_cubit.dart';

class UsersView extends StatelessWidget with Loaders {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfilesCubit>().loadExistingProfiles();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: AdaptivePadding(
        child: BlocBuilder<ProfilesCubit, ProfilesState>(
            builder: (context, ProfilesState profilesState) {
          if (profilesState is ProfilesStateLoaded) {
            return _buildView(context, profilesState.profiles, profilesState.selectedProfile);
          } else {
            return circularLoader();
          }
        }),
      ),
    );
  }

  Widget _buildView(BuildContext context, List<ProfileEntity> profiles, ProfileEntity? profile) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'asset/daily_tracker/auth/user_landscape_image.png',
              ),
              opacity: 0.1,
              fit: BoxFit.cover)),
      child: AdaptiveContainer(
        child: profiles.isEmpty ? _buildCreateUser() : _buildProfiles(profiles, profile),
      ),
    );
  }

  Widget _buildProfiles(List<ProfileEntity> profiles, ProfileEntity? selectedProfile) {
    return Builder(builder: (context) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Profiles',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ListView.separated(
                      itemCount: profiles.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var profile = profiles.elementAt(index);
                        return ListTile(
                          leading: const Icon(Icons.school),
                          title: Text(profile.name),
                          selected: profile.isSelected,
                          selectedTileColor: Colors.green,
                          onTap: () => context.read<ProfilesCubit>().onSelectionOfProfile(profile.id),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider())
                ],
              ),
            ),
           if(selectedProfile != null) _buildProfileDetails(selectedProfile)
          ]);
    });
  }

  Widget _buildProfileDetails(ProfileEntity profile) {
    return  Builder(
      builder: (context) {
        return Flexible(
          flex: 2,
          child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text('Text : ${profile.name}'),
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () {
                          final GetIt injector = GetIt.instance;
                          final task = injector<ProfileExecutedTask>(); // No context needed
                          task.setProfile = profile;
                          GoRouter.of(context).go('/home/daily-tracker');
                        },
                        child: const Text('GO')),
                  )
                ],
              )),
        );
      }
    );
  }


  Widget _buildCreateUser() {
    return Builder(builder: (context) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Right you don\'s users create one'),
              ElevatedButton(onPressed: () {}, child: const Text('Create User')),
              ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/home/daily-tracker');
                    // final GetIt injector = GetIt.instance;
                    // injector<ProfileExecutedTask>().setProfile = pro;
                  },
                  child: const Text('GO'))
            ],
          ),
        ),
      );
    });
  }
}
