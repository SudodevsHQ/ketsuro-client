import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:ketsuro/src/common/colors.dart';
import 'package:ketsuro/src/components/login/index.dart';
import 'package:ketsuro/src/config/config.dart';
import 'package:ketsuro/src/screens/index.dart';
import 'package:ketsuro/src/screens/loading.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends MomentumState<Home> with RelativeScale {
  var res = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  void initMomentumState() async {
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
    // print(subs.items);
    subs.items.forEach((element) {
      print(element.snippet.title +
          'https://www.youtube.com/watch?v=' +
          element.id);

      res.add({
        'url': 'https://www.youtube.com/watch?v=' + element.id,
        'title': element.snippet.title,
        'channel': element.snippet.channelTitle,
        'thumbnail': element.snippet.thumbnails.high.url
      });
    });

    setState(() {});
    super.initMomentumState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trending Videos',
          style: TextStyle(color: ketsuroBgWhite, fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: ketsuroBgWhite),
          onPressed: () async {
            var controller = Momentum.controller<LoginController>(context);
            await controller.signOutGoogle();
            Momentum.restart(context, momentum());
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.ac_unit),
            onPressed: () async {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => Details(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: sx(30), right: sx(30), top: sy(10)),
        child: res.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: res.length,
                itemBuilder: (context, index) {
                  var current = res[index];
                  return VideoCard(
                    channel: current['channel'],
                    title: current['title'],
                    thumbnail: current['thumbnail'],
                    url: current['url'],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: sy(6)),
              ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final String thumbnail;
  final String url;
  final String title;
  final String channel;

  const VideoCard({Key key, this.thumbnail, this.url, this.title, this.channel})
      : super(key: key);
  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> with RelativeScale {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initRelativeScaler(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: ketsuroGrey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 360 / 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: widget.thumbnail,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Center(
                      child: Image.asset(
                    'assets/undraw_video_files_fu10 1.png',
                    scale: 3,
                  ));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 8, bottom: 24, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: sx(20),
                      color: ketsuroBlack,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  widget.channel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: sx(15),
                      color: ketsuroGrey,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
