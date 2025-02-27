import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sample_latest/bloc/daily_status_tracker/daily_status_tracker_bloc.dart';
import 'package:sample_latest/core/mixins/dialogs.dart';
import 'package:sample_latest/core/mixins/loaders.dart';
import 'package:sample_latest/models/daily_tracker/daily_tracker_event_model.dart';
import 'package:sample_latest/ui/daily_tracker/check_in_btn.dart';
import 'package:sample_latest/ui/daily_tracker/create_tracker_event.dart';
import 'package:sample_latest/ui/daily_tracker/digital_clock.dart';
import 'package:sample_latest/ui/daily_tracker/existing_events.dart';
import 'package:sample_latest/ui/daily_tracker/today_events.dart';
import 'package:sample_latest/utils/enums_type_def.dart';

import 'time_of_day_message.dart';

class DailyTrackerHome extends StatefulWidget {
  const DailyTrackerHome({super.key});

  @override
  State<DailyTrackerHome> createState() => _DailyTrackerHomeState();
}

class _DailyTrackerHomeState extends State<DailyTrackerHome>
    with TickerProviderStateMixin, Loaders, CustomDialogs {
  final player = AudioPlayer();

  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );


  @override
  void initState() {
    controller.value = 1;
    // WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<DailyTrackerStatusBloc>().getCheckInStatus();
    // });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: onCreateOfEvent,
          label: const Text('Create Event'),
          icon: const Icon(Icons.add)),
      body: _buildTimeOfDay(),
    );
  }

  Widget _buildTimeOfDay() {
    return BlocBuilder<DailyTrackerStatusBloc, DailyStatusTrackerState>(
        buildWhen: (oldState, currentState) {
          if (currentState is DailyStatusTrackerCheckInStatus && currentState.isCheckedIn) {
            controller.reverse();
          }
            return   currentState.dailyStatusTrackerLoadedType ==
              DailyStatusTrackerLoadedType.greeting;
        },
        builder: (context, DailyStatusTrackerState trackState) {
          if (trackState is DailyStatusTrackerCheckInStatus) {
            return _buildGreetingStatus(trackState, trackState.events);
          } else {
            return circularLoader();
          }
        });
  }

  Widget _buildGreetingStatus(DailyStatusTrackerCheckInStatus trackStatus, List<DailyTrackerEventModel> events) {
    print('##** ${events.length}');
    var greetingText = greeting(trackStatus.timeOfDay);
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: greetingText,
        style: Theme.of(context).textTheme.displayLarge?.apply(
            fontSizeDelta: 40,
            color: Colors.white,
            fontFamily: GoogleFonts.notoSerif().fontFamily),
      ),
      maxLines: 2, // Set maxLines to control height based on lines
      textDirection: TextDirection.ltr,
    );
    // Layout the text with an infinite width
    textPainter.layout(maxWidth: double.infinity);

    double timerHeight = 200;
    double checkInHeight = 150;
    double textInHeight = textPainter.size.height;

    var totalHeight = timerHeight + checkInHeight + textInHeight + 20;
    var size = MediaQuery.of(context).size;
    var firstItemTopPosition = (size.height - totalHeight) / 2;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image:
                AssetImage('asset/daily_tracker/pre_checkin_background.png')),
      ),
      child: Stack(
        children: [
          DailyTrackerDigitalClock(
              position: (
            top: firstItemTopPosition,
            left: size.width / 2 - checkInHeight / 2,
          ),
          controller: controller,
          ),
          TimeOfDayMessage(title: greetingText, position: (top : firstItemTopPosition + timerHeight + 10, left : size.width / 2 - textPainter.size.width / 2), callback: (){}, textSizeDetails: textPainter.size, controller: controller),
          CheckInBtn(
            position: (
              top: firstItemTopPosition + timerHeight + textInHeight + 20,
              left: (size.width / 2) - (150/2)
            ),
            callback: trackStatus.isCheckedIn ? showEvents : onCheckIn,
            controller: controller,
          ),
         if(trackStatus.isCheckedIn) Positioned(
              top: 100,
              left: 50,
              child: TodayEventsView(events))
        ],
      ),
    );
  }

  String greeting(PartsOfDay timeOfDay) {
    return switch (timeOfDay) {
      PartsOfDay.morning => 'Hello Good Morning',
      PartsOfDay.afternoon => 'Good After Noon',
      PartsOfDay.evening => 'Good Evening',
      PartsOfDay.night => 'Good Night',
      PartsOfDay.allDay => '',
      PartsOfDay.customTime => '',
    };
  }

  void onCreateOfEvent() {
    adaptiveDialog(context, const CreateDailyTrackerEvent());
  }

  void onCheckIn() async {
    final duration = await player.setAsset(// Load a URL
        'asset/sound_effects/check_in.mp3');
    player.play();
    await controller.reverse();
    context.read<DailyTrackerStatusBloc>().checkIn();
  }

  void showEvents() {
    adaptiveDialog(context, ExistingEventsView());
  }
}
