// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:momentum/momentum.dart';
import 'package:youtube_api/youtube_api.dart';

// Project imports:
import 'package:ketsuro/src/data/index.dart';
import 'index.dart';

// Project imports:


class YoutubeController extends MomentumController<YoutubeModel> {
  @override
  Future<void> bootstrapAsync() async {
    await getTrendingTech('Jerry rig everything');
    await getCacheVideos();
    await doRequest();
    return super.bootstrapAsync();
  }

  @override
  YoutubeModel init() {
    return YoutubeModel(this, videos: []);
  }

  Future getTrendingTech(String query) async {
    List<VideoData> res = [];

    String key = 'AIzaSyDdOIWH8lMlUFwAV0vQTM68Xfars8u7MJc';
    YoutubeAPI ytApi = new YoutubeAPI(key);

    var ress = await ytApi.search(
      query,
    );
    ress.forEach((element) {
      res.add(VideoData(
          url: 'https://www.youtube.com/watch?v=' + element.id,
          title: element.title,
          channel: element.channelTitle,
          thumbnail: element.thumbnail['high']['url'],
          id: element.id));
    });
    res.removeAt(0);
    model.update(videos: res);
  }

  Future getCacheVideos() async {
    var videoIds = model.videos.map((e) => e.id).toList();
    print(videoIds);
    // ignore: cancel_subscriptions
    var videoSubscription = FirebaseFirestore.instance
        .collection('video')
        .where('video_id', whereIn: videoIds)
        .snapshots()
        .listen((querySnapshot) {
      model.update(videoSnapshot: querySnapshot);
      model.videoSubscription.onError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });
    });

    model.update(videoSubscription: videoSubscription);
  }

  Future doRequest() async {
    var videoIds = model.videos.map((e) => e.id).toList();
    print(videoIds);
    var snapshot = model.videoSnapshot;
    try {
      // print(snapshot.docs.length);
      var ok = snapshot.docs.map((e) => e.data()['video_id']).toList();
      print(ok);
      for (var id in videoIds) {
        if (!ok.contains(id)) {
          var res = await http.get('https://api.metaboy.info/video/$id');
          print(res.reasonPhrase);
          print('noexist');
        }
      }
    } catch (e) {
      for (var id in videoIds) {
        var res = await http.get('https://api.metaboy.info/video/$id');
        print(res.reasonPhrase);
        print('request');
      }
    }
  }

  Future<void> disposeStream() async {
    await model.videoSubscription.cancel();
  }

  Future getVideo(String requestId, String id) async {
    var res = await http.get(
        'https://api.metaboy.info/summarize/$id?request_id=$requestId');
    print(res.body);
  }

  Future<bool> addQuestion() async {
    try {
      await FirebaseFirestore.instance
          .collection('video')
          .doc('test')
          .set({'video_id': 'sdfsfsfs'});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
