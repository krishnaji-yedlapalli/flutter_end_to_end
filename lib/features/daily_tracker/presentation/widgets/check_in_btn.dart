import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class CheckInBtn extends StatefulWidget {
  final ({double top, double left}) position;
  final VoidCallback callback;
  final AnimationController controller;

  const CheckInBtn(
      {super.key,
      required this.position,
      required this.callback,
      required this.controller});

  @override
  State<CheckInBtn> createState() => CheckInBtnState();
}

class CheckInBtnState extends State<CheckInBtn> {
  late Animation<Rect?> _rectAnimation;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _rectAnimation = RectTween(
      begin: Rect.fromLTWH(size.width - 170, 20, 150, 50),
      end: Rect.fromLTWH(widget.position.left, widget.position.top, 150, 150),
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
                  ? RippleAnimation(
                      color: Colors.lightGreenAccent,
                      delay: const Duration(milliseconds: 300),
                      repeat: true,
                      minRadius: 75,
                      ripplesCount: 6,
                      duration: const Duration(milliseconds: 6 * 300),
                      child: InkResponse(
                        onTap: widget.callback,
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
                  : ElevatedButton.icon(
                      onPressed: widget.callback,
                      label: Text('Events'),
                      icon: Icon(Icons.event)));
        });
  }
}
