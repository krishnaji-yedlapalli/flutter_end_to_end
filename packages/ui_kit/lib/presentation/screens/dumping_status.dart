import 'package:app_core/core/data/db/offline_handler.dart';
import 'package:app_core/core/utils/enums_type_def.dart';
import 'package:ui_kit/mixins/mixins.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class DumpingStatusView extends StatefulWidget {
  const DumpingStatusView({super.key});

  @override
  State<DumpingStatusView> createState() => _DumpingStatusViewState();
}

class _DumpingStatusViewState extends State<DumpingStatusView>
    with CustomDialogs, HelperWidget {
  OfflineHandler get _offlineHandler => GetIt.instance<OfflineHandler>();

  @override
  void initState() {
    _offlineHandler.dumpingOfflineDataStatus.listen((value) {
      if (mounted && value == null) {
        GoRouter.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return dialogWithButtons(
        title: 'Dumping Offline Data',
        content: _buildView(),
        actions: ['Run In Background'],
        callBack: (index) => onTapOfAction(context, index));
  }

  Widget _buildView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStreamBuilder(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: RichText(
                text: const TextSpan(children: [
              TextSpan(
                  text: 'Note :',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(
                  text:
                      ' In dumping process, we extract huge amounts of school and student data from a zip file and store it in a local database. This entire process runs in an isolate, ensuring a smoother experience without cluttering the UI screen with unnecessary details.',
                  style: TextStyle(color: Colors.black))
            ])),
          )
        ],
      ),
    );
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder<OfflineDumpingStatus>(
      stream: _offlineHandler.dumpingOfflineDataStatus.stream,
      builder: (context, snapshot) {
        OfflineDumpingStatus? status = snapshot.data;
        if (status != null) {
          return _buildDownloadingStatus(status);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildDownloadingStatus(OfflineDumpingStatus status) {
    if (status == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.asset(
                    status.percentage >= 100
                        ? 'asset/gifs/happy.gif'
                        : 'asset/gifs/waiting.gif',
                    height: 100,
                  ),
                ),
                Text(status.title,
                    style: const TextStyle(color: Colors.orange)),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                  height: 100,
                  width: 100,
                  child: LiquidCircularProgressIndicator(
                    value: (status.percentage) / 100,
                    direction: Axis.vertical,
                  )),
            ),
          )
        ],
      ),
    );
  }

  void onTapOfAction(BuildContext context, int index) {
    GoRouter.of(context).pop();
  }
}
