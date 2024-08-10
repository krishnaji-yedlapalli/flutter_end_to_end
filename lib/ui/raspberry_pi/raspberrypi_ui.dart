import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:one_clock/one_clock.dart';
import 'package:sample_latest/bloc/daily_status_tracker/daily_status_tracker_bloc.dart';
import 'package:sample_latest/mixins/dialogs.dart';
import 'package:sample_latest/mixins/loaders.dart';
import 'package:sample_latest/ui/raspberry_pi/create_tracker_event.dart';
import 'package:sample_latest/ui/raspberry_pi/daily_tracker_event_list.dart';
import 'package:sample_latest/utils/device_configurations.dart';
import 'package:sample_latest/utils/enums_type_def.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class RaspberrypiHome extends StatefulWidget {
  const RaspberrypiHome({super.key});

  @override
  State<RaspberrypiHome> createState() => _RaspberrypiHomeState();
}

class _RaspberrypiHomeState extends State<RaspberrypiHome>
    with Loaders, CustomDialogs {

  final player = AudioPlayer();                   // Create a player

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<DailyTrackerStatusBloc>().getCheckInStatus();
    });
    super.initState();
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
        buildWhen: (oldState, currentState) =>
            oldState.dailyStatusTrackerLoadedType ==
            DailyStatusTrackerLoadedType.greeting,
        builder: (context, DailyStatusTrackerState trackState) {
          if (trackState is DailyStatusTrackerCheckInStatus) {
            if (!trackState.isCheckedIn) {
              return _buildGreetingStatus(trackState);
            }
            return _buildEventListDetails();
          } else {
            return circularLoader();
          }
        });
  }

  Widget _buildGreetingStatus(DailyStatusTrackerCheckInStatus trackStatus) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image:
                AssetImage('asset/daily_tracker/pre_checkin_background.png')),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnalogClock(
            decoration: BoxDecoration(
                border: Border.all(width: 3.0, color: Colors.black),
                color: Colors.transparent,
                shape: BoxShape.circle),
            width: 200.0,
            height: 200.0,
            isLive: true,
            hourHandColor: Colors.black,
            minuteHandColor: Colors.black,
            showSecondHand: true,
            numberColor: Colors.black87,
            showNumbers: true,
            showAllNumbers: false,
            textScaleFactor: 1.4,
            showTicks: true,
            showDigitalClock: true,
            // datetime: DateTime(2019, 1, 1, 9, 12, 15),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(greeting(trackStatus.timeOfDay),
                style: Theme.of(context).textTheme.displayLarge?.apply(
                    fontSizeDelta: 40,
                    color: Colors.white,
                    fontFamily: GoogleFonts.notoSerif().fontFamily)),
          ),
          RippleAnimation(
            color: Colors.lightGreenAccent,
            delay: const Duration(milliseconds: 300),
            repeat: true,
            minRadius: 75,
            ripplesCount: 6,
            duration: const Duration(milliseconds: 6 * 300),
            child: InkResponse(
              onTap: onCheckIn,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset(
                    'asset/daily_tracker/daily_tracker_check_in.png',
                    height: 150,
                    width: 150,
                  )),
            ),
          )

          // ElevatedButton(onPressed: context.read<DailyTrackerStatusBloc>().checkIn,
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: DeviceConfiguration.isMobileResolution ? null : Size(200, 80)
          //     ),
          //     child: Text('Check In', style: TextStyle(fontSize: DeviceConfiguration.isMobileResolution ? null : 40)))
        ],
      ),
    );
  }

  Widget _buildEventListDetails() {
    return Container();
  }

  String greeting(PartsOfDay timeOfDay) {
    return switch (timeOfDay) {
      PartsOfDay.morning => 'Hello Good Morning',
      PartsOfDay.afternoon => 'Good After Noon',
      PartsOfDay.evening => 'Good Evening',
      PartsOfDay.night => 'Good Night',
    };
  }

  void onCreateOfEvent() {
    adaptiveDialog(context, const CreateDailyTrackerEvent());
  }

  void onCheckIn() async {
    final duration = await player.setAsset(           // Load a URL
        'asset/sound_effects/check_in.mp3');
    player.play();

  }
}
