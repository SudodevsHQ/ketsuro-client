import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:ketsuro/src/config/config.dart';
import 'package:ketsuro/src/data/index.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class YoutubeController extends MomentumController<YoutubeModel> {
  @override
  YoutubeModel init() {
    return YoutubeModel(
      this,
      videos: []
    );
  }

  Future getTrendingTech() async {
    List<VideoData> res = [];
    var httpClient = await clientViaServiceAccount(credentials, scopes);

    var youtube = new YoutubeApi(httpClient);
    var subs = await youtube.videos.list(
      [
        'snippet',
      ],
      chart: 'mostPopular',
      videoCategoryId: '28',
      maxResults: 10,
      regionCode: 'US',
    );
    subs.items.forEach((element) {
      print(element.snippet.title +
          'https://www.youtube.com/watch?v=' +
          element.id);

      res.add(VideoData(
        url: 'https://www.youtube.com/watch?v=' + element.id,
        title: element.snippet.title,
        channel: element.snippet.channelId,
        thumbnail: element.snippet.thumbnails.maxres.url,
      ));
    });

    model.update(videos: res);
  }
}
