import 'package:ketsuro/src/data/index.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class YoutubeModel extends MomentumModel<YoutubeController> {
  YoutubeModel(YoutubeController controller, {this.videos}) : super(controller);

  final List<VideoData> videos;

  @override
  void update({final List<VideoData> videos}) {
    YoutubeModel(
      controller,
      videos: videos ?? this.videos
    ).updateMomentum();
  }
}
