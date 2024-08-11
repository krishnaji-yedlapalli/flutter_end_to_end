import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class DailyTrackerDigitalClock extends StatefulWidget {
  final ({double top, double left}) position;
  final AnimationController controller;

  const DailyTrackerDigitalClock({super.key, required this.position, required this.controller});

  @override
  State<DailyTrackerDigitalClock> createState() =>
      DailyTrackerDigitalClockState();
}

class DailyTrackerDigitalClockState extends State<DailyTrackerDigitalClock>
    with TickerProviderStateMixin {

  late Animation<Rect?> _rectAnimation;

  @override
  void initState() {
    _rectAnimation = RectTween(
      begin: const Rect.fromLTWH(50, 10, 100, 50),
      end: Rect.fromLTWH(widget.position.left, widget.position.top, 200, 200),
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return Positioned.fromRect(
              rect: _rectAnimation.value!,
              child: _rectAnimation.value!.top > 100
                  ? AnalogClock(
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
                    )
                  : DigitalClock(
                      showSeconds: true,
                      isLive: true,
                      digitalClockTextColor: Colors.white,
                      textScaleFactor: 1.5,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      datetime: DateTime.now()));
        });
  }
}
