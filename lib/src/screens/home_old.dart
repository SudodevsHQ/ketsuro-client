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
import 'package:ketsuro/src/widgets/video_card.dart';
import 'package:momentum/momentum.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../main.dart';

class HomeOld extends StatefulWidget {
  @override
  _HomeOldState createState() => _HomeOldState();
}

class _HomeOldState extends MomentumState<HomeOld> with RelativeScale {
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
