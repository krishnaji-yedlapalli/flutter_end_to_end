import 'package:app_core/core/data/db/cubit/db_config_cubit.dart';
import 'package:app_core/core/data/db/cubit/db_config_state.dart';
import 'package:app_core/core/data/db/db_config_repository.dart';
import 'package:app_core/core/data/db/offline_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ui_kit/mixins/mixins.dart';

class DbConfigurationDialog extends StatelessWidget with CustomDialogs {
  const DbConfigurationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DbConfigCubit(GetIt.instance<DbConfigRepository>()),
      child: BlocBuilder<DbConfigCubit, DbConfigState>(
        builder: (context, state) {
          final cubit = context.read<DbConfigCubit>();
          return dialogWithButtons(
              title: "!!! Hey Dev's !!!",
              content: _buildForm(context, cubit, state),
              actions: ['Close'],
              callBack: (index) async {
                final shouldDump = await cubit.save();
                if (shouldDump) {
                  GetIt.instance<OfflineHandler>().dumpOfflineData();
                }
                if (context.mounted) Navigator.pop(context);
              });
        },
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, DbConfigCubit cubit, DbConfigState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select atleast one option to enable and configure the DB',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.apply(color: Colors.deepOrangeAccent)),
            CheckboxListTile(
                title: const Text('Offline Mode'),
                subtitle: const Text(
                    'Stores the data in Local db only when there was no internet. Once internet is back data will Sync automatically with server and delete the local data'),
                isThreeLine: true,
                value: state.storeOnlyIfOffline,
                onChanged: (status) => cubit.onSelection(0, status ?? false)),
            const Divider(),
            CheckboxListTile(
                title: const Text('Online & Offline Mode'),
                subtitle: const Text(
                    'Irrespective of Internet data will be stored in local db and data will be deleted based on the configured date'),
                isThreeLine: true,
                value: state.storeInBothOfflineAndOnline,
                onChanged: (status) => cubit.onSelection(1, status ?? false)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                          'How long should local data be stored from its creation or last update date?',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black26))),
                  DropdownButton(
                      value: state.howLongDataShouldPersist,
                      items: [2, 5, 10, 15, 20, 25, 30]
                          .map((days) => DropdownMenuItem(
                              value: days, child: Text('$days days')))
                          .toList(),
                      onChanged: (days) =>
                          cubit.updateHowLongDataShouldPersist(days ?? 2))
                ],
              ),
            ),
            const Divider(),
            CheckboxListTile(
                title: const Text('Dumping Offline Data'),
                subtitle: const Text(
                    'Data will be dumped into the local DB at the time login or Module loading. Later it is used making some operations'),
                isThreeLine: true,
                value: state.dumpOfflineData,
                onChanged: (status) => cubit.onSelection(2, status ?? false)),
          ],
        ),
      ),
    );
  }
}
