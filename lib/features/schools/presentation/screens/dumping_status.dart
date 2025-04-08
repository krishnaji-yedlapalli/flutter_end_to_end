import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/helper_widgets_mixin.dart';
import 'package:sample_latest/core/data/db/offline_handler.dart';
import 'package:sample_latest/core/utils/enums_type_def.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class DumpingStatusView extends StatefulWidget {
  const DumpingStatusView({super.key});

  @override
  State<DumpingStatusView> createState() => _DumpingStatusViewState();
}

class _DumpingStatusViewState extends State<DumpingStatusView>
    with CustomDialogs, HelperWidget {
  @override
  void initState() {
    OfflineHandler().dumpingOfflineDataStatus.listen((value) {
      if (mounted && value == null) {
        GoRouter.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // OfflineHandler().dumpingOfflineDataStatus.r
    super.dispose();
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
      stream: OfflineHandler().dumpingOfflineDataStatus.stream,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              // direction: Axis.vertical,
              // crossAxisAlignment: WrapCrossAlignment.center,
              // spacing : 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               Padding(
                 padding: const EdgeInsets.only(bottom: 8.0),
                 child: Image.asset(status!.percentage >= 100 ? 'asset/gifs/happy.gif' : 'asset/gifs/waiting.gif', height: 100,),
               ),
                Text(status.title, style: TextStyle(color: Colors.orange)),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: LiquidCircularProgressIndicator(
                      value: (status?.percentage ?? 0)/100, // Defaults to 0.5.
                      // valueColor: AlwaysStoppedAnimation(Colors
                      //     .pink), // Defaults to the current Theme's accentColor.
                      // backgroundColor: Colors
                      //     .white, // Defaults to the current Theme's backgroundColor.
                      // borderColor: Colors.red,
                      // borderWidth: 5.0,
                      direction: Axis
                          .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                      // center: Text("Loading..."),
                    )
              ),
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
