import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeOfDayMessage extends StatefulWidget {
  final String title;
  final ({double top, double left}) position;
  final VoidCallback callback;
  final Size textSizeDetails;
  final AnimationController controller;

  const TimeOfDayMessage(
      {super.key,
      required this.title,
      required this.position,
      required this.callback,
      required this.textSizeDetails,
      required this.controller});

  @override
  State<TimeOfDayMessage> createState() => _TimeOfDayMessageState();
}

class _TimeOfDayMessageState extends State<TimeOfDayMessage>
    with TickerProviderStateMixin {
  late Animation<Rect?> _rectAnimation;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _rectAnimation = RectTween(
      begin: Rect.fromLTWH(size.width / 2 - 100, 20, 300, 50),
      end: Rect.fromLTWH(widget.position.left, widget.position.top,
          widget.textSizeDetails.width, widget.textSizeDetails.height),
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return Positioned.fromRect(
              rect: _rectAnimation.value!,
              child: _rectAnimation.value!.top > 100
                  ? Text(widget.title,
                      style: Theme.of(context).textTheme.displayLarge?.apply(
                          fontSizeDelta: 40,
                          color: Colors.white,
                          fontFamily: GoogleFonts.notoSerif().fontFamily))
                  : Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                          onPressed: () {},
                          label: const Text('Events'),
                          icon: const Icon(Icons.event))));
        });
  }
}
