// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:momentum/momentum.dart';

// Project imports:
import 'package:ketsuro/src/data/index.dart';
import 'index.dart';

class YoutubeModel extends MomentumModel<YoutubeController> {
  YoutubeModel(
    YoutubeController controller, {
    this.videos,
    this.videoSubscription,
    this.videoSnapshot,
  }) : super(controller);

  final List<VideoData> videos;
  final StreamSubscription<QuerySnapshot> videoSubscription;
  final QuerySnapshot videoSnapshot;

  @override
  void update({
    final List<VideoData> videos,
    StreamSubscription<QuerySnapshot> videoSubscription,
    QuerySnapshot videoSnapshot,
  }) {
    YoutubeModel(
      controller,
      videos: videos ?? this.videos,
      videoSnapshot: videoSnapshot ?? this.videoSnapshot,
      videoSubscription: videoSubscription ?? this.videoSubscription,
    ).updateMomentum();
  }
}
