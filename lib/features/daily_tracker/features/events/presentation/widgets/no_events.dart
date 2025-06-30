

import 'package:flutter/material.dart';

import '../../../../../../core/mixins/helper_widgets_mixin.dart';

class NoEventsToDisplay extends StatelessWidget with HelperWidget {
  const NoEventsToDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.8),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: emptyMessage('No Events to display')
    );
  }
}
