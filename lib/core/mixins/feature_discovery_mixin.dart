import 'package:flutter/material.dart';

mixin FeatureDiscovery {
  Widget featureDiscovery(VoidCallback callback) {
    return Tooltip(
        message: 'Feature Discovery',
        child: InkResponse(
            onTap: callback,
            child: Image.asset('asset/icons/discover.png',
                height: 30, width: 30, color: Colors.white)));
  }
}
