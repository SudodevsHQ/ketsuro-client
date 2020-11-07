import 'package:ketsuro/src/data/index.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class YoutubeModel extends MomentumModel<YoutubeController> {
  YoutubeModel(YoutubeController controller, {this.video}) : super(controller);

  final VideoData video;

  @override
  void update({final VideoData video}) {
    YoutubeModel(
      controller,
      video: video ?? this.video
    ).updateMomentum();
  }
}
