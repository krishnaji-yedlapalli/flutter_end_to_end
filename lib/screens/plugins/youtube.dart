
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Youtube extends StatelessWidget {
    Youtube({Key? key}) : super(key: key);

  final YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=sozlt0eA8aQ&t=2416s&ab_channel=RawTalksWithVK") ?? '',
      flags:  const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ));

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      // videoProgressIndicatorColor: Colors.amber,
      // progressColors: ProgressColors(
      //   playedColor: Colors.amber,
      //   handleColor: Colors.amberAccent,
      // ),
      onReady : () {
    // _controller.addListener(listener);
    },
    );
  }
}
